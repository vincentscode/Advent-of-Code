defmodule Loader do
  def read_lines(filename) do
    File.read!(filename) |> String.split("\n", trim: true)
  end
end

defmodule Main do
  def pad_lines(lines) do
    line_length = String.length(Enum.at(lines, 0))
    additional = String.duplicate(".", line_length)
    [additional] ++ lines ++ [additional]
  end

  def get_surrounding_symbols(lines, x, y) do
    [
      Enum.at(lines, y - 1) |> String.at(x - 1), Enum.at(lines, y - 1) |> String.at(x), Enum.at(lines, y - 1) |> String.at(x + 1),
      Enum.at(lines, y + 0) |> String.at(x - 1),                                        Enum.at(lines, y + 0) |> String.at(x + 1),
      Enum.at(lines, y + 1) |> String.at(x - 1), Enum.at(lines, y + 1) |> String.at(x), Enum.at(lines, y + 1) |> String.at(x + 1)
    ]
  end

  def get_surrounding_valid_symbol_coordinates(lines, x, y, valid_symbols) do
      get_surrounding_symbols(lines, x, y)
      |> Enum.with_index(0)
      |> Enum.filter(fn {symbol, _} -> Enum.member?(valid_symbols, symbol) end)
      |> Enum.map(fn {_, i} -> i end)
      |> Enum.map(fn i -> case i do
        0 -> {x - 1, y - 1}
        1 -> {x, y - 1}
        2 -> {x + 1, y - 1}
        3 -> {x - 1, y}
        4 -> {x + 1, y}
        5 -> {x - 1, y + 1}
        6 -> {x, y + 1}
        7 -> {x + 1, y + 1}
      end end)
    end

  def surrounding_symbols_contain_any?(lines, x, y, symbols) do
    get_surrounding_symbols(lines, x, y) |> Enum.any?(fn symbol -> Enum.member?(symbols, symbol) end)
  end

  def all_indices_between(start, length) do
    start..(start + length - 1)
  end

  def main() do
    valid_symbols = ["*"]
    raw_lines = Loader.read_lines("input.txt")
    lines = pad_lines(raw_lines)

    words_with_coordinates = lines
      # get indices of words
      |> Enum.map(fn line -> Regex.scan(~r/\d+/, line, return: :index) end)
      # unpack nested list
      |> Enum.map(fn line -> Enum.map(line, fn [x] -> x end) end)
      # add index to front of each list
      |> Enum.with_index(0) |> Enum.map(fn {k, v} -> {v, k} end)
      # convert {start, length} to range
      |> Enum.map(fn {i, indices} -> {i, Enum.map(indices, fn {start, length} -> all_indices_between(start, length) end)} end)
      # check if surrounding symbols contain any valid symbols
      |> Enum.map(fn {i, indices} -> {i, Enum.map(indices, fn range -> {range, range |> Enum.map(fn r -> get_surrounding_valid_symbol_coordinates(lines, r, i, valid_symbols) end)} end)} end)
      # flatten coordinates
      |> Enum.map(fn {i, indices} -> {i, Enum.map(indices, fn {range, coordinates} -> {range, List.flatten(coordinates)} end)} end)
      # unique coordinates
      |> Enum.map(fn {i, indices} -> {i, Enum.map(indices, fn {range, coordinates} -> {range, Enum.uniq(coordinates)} end)} end)
      # filter out ranges that don't contain any valid coordinates
      |> Enum.map(fn {i, indices} -> {i, Enum.filter(indices, fn {_, coordinates} -> Enum.count(coordinates) > 0 end)} end)
      |> Enum.filter(fn {_, indices} -> Enum.count(indices) > 0 end)
      # reconstruct words
      |> Enum.map(fn {i, indices} -> Enum.map(indices, fn {range, coordinates} -> {String.slice(Enum.at(lines, i), range), coordinates} end) end)
      # flatten result
      |> List.flatten()

    word_pairs = words_with_coordinates
      |> Enum.map(fn {word, coordinates} -> Enum.map(coordinates, fn {x, y} -> {{x, y}, word} end) end)
      |> List.flatten()
      |> Enum.group_by(fn {coordinates, _} -> coordinates end)
      |> Enum.map(fn {coordinates, words} -> {coordinates, Enum.map(words, fn {_, word} -> word end)} end)
      |> Enum.filter(fn {_, words} -> Enum.count(words) > 1 end)
      |> Enum.map(fn {_, words} -> Enum.map(words, fn word -> String.to_integer(word) end) end)

    pair_product_sum = word_pairs
      |> Enum.map(fn words -> Enum.reduce(words, 1, fn word, acc -> word * acc end) end)
      |> Enum.sum()

    IO.inspect(pair_product_sum)
    end
end

Main.main()
