defmodule Loader do
  def read_lines(filename) do
    File.read!(filename) |> String.split("\n", trim: true)
  end
end

defmodule Parser do
  def _find_all_digits(line) do
    word_to_digit = %{
      "1" => "1",
      "2" => "2",
      "3" => "3",
      "4" => "4",
      "5" => "5",
      "6" => "6",
      "7" => "7",
      "8" => "8",
      "9" => "9",
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }
    regexes = [
      ~r/\d/,
      ~r/one/,
      ~r/two/,
      ~r/three/,
      ~r/four/,
      ~r/five/,
      ~r/six/,
      ~r/seven/,
      ~r/eight/,
      ~r/nine/
    ]

    result = regexes
      # find all words individually
      |> Enum.map(fn regex -> Regex.scan(regex, line, return: :index) end)
      |> List.flatten()
      # restore word
      |> Enum.map(fn {start, length} -> {start, length, String.slice(line, start, length)} end)
      # convert to number
      |> Enum.map(fn {start, length, word} -> {start, length, Map.get(word_to_digit, word)} end)
      # sort by start index
      |> Enum.sort(fn {start1, _, _}, {start2, _, _} -> start1 < start2 end)
      |> Enum.map(fn {_, _, digit} -> digit end)

    result
  end

  def parse_line(line) do
    digits = _find_all_digits(line)
    first_digit = List.first(digits)
    last_digit = List.last(digits)
    combined = first_digit <> last_digit
    result = String.to_integer(combined)
    result
  end
end

defmodule Main do
  def main() do
    lines = Loader.read_lines("input.txt")
    sum = Enum.reduce(lines, 0, fn line, acc -> acc + Parser.parse_line(line) end)
    IO.puts(sum)
  end
end

Main.main()
