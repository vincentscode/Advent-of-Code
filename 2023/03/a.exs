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

  def surrounding_symbols_contain_any?(lines, x, y, symbols) do
    get_surrounding_symbols(lines, x, y) |> Enum.any?(fn symbol -> Enum.member?(symbols, symbol) end)
  end

  def all_indices_between(start, length) do
    start..(start + length - 1)
  end

  def main() do
    valid_symbols = ["@", "&", "*", "$", "-", "#", "=", "%", "+", "/"]
    raw_lines = Loader.read_lines("input.txt")
    lines = pad_lines(raw_lines)

    valid_words = lines
      # get indices of words
      |> Enum.map(fn line -> Regex.scan(~r/\d+/, line, return: :index) end)
      # unpack nested list
      |> Enum.map(fn line -> Enum.map(line, fn [x] -> x end) end)
      # add index to front of each list
      |> Enum.with_index(0) |> Enum.map(fn {k, v} -> {v, k} end)
      # convert {start, length} to range
      |> Enum.map(fn {i, indices} -> {i, Enum.map(indices, fn {start, length} -> all_indices_between(start, length) end)} end)
      # check if surrounding symbols contain any valid symbols
      |> Enum.map(fn {i, indices} -> {i, Enum.map(indices, fn range -> {range, range |> Enum.any?(fn r -> surrounding_symbols_contain_any?(lines, r, i, valid_symbols) end)} end)} end)
      # filter out invalid words
      |> Enum.map(fn {i, indices} -> {i, Enum.filter(indices, fn {_, valid} -> valid end)} end)
      # reconstruct words from indices
      |> Enum.map(fn {i, indices} -> Enum.map(indices, fn {range, _} -> String.slice(Enum.at(lines, i), range) end) end)
      # flatten result
      |> Enum.reduce([], fn list, acc -> acc ++ list end)
      # to int
      |> Enum.map(fn word -> String.to_integer(word) end)

    IO.inspect(valid_words)

    # sum
    IO.inspect(Enum.sum(valid_words))

    end
end

Main.main()
