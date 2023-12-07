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

  def parse_line(line) do
    digits = _find_digits(line)
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
