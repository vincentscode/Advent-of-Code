defmodule Loader do
  def read_lines(filename) do
    File.read!(filename) |> String.split("\n", trim: true)
  end
end

defmodule Parser do
  def _find_digits(line) do
    Regex.scan(~r/\d/, line)
      |> Enum.map(fn [char] -> char end)
  end

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
    Regex.scan(~r/\d|one|two|three|four|five|six|seven|eight|nine/, line)
      |> Enum.map(fn [char] -> char end)
      |> Enum.map(fn char -> Map.get(word_to_digit, char, char) end)
    end

  def parse_line(line) do
    # digits = _find_digits(line)
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
