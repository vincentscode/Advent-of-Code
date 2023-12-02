defmodule Loader do
  def read_lines(filename) do
    File.read!(filename) |> String.split("\n", trim: true)
  end
end

defmodule Cube do
  defstruct [:color, :count]
end

defmodule Game do
  defstruct [:number, :draws]
end

defmodule Parser do
  def parse_line(line) do
    [game, draws] = String.split(line, ": ")
    game_number = String.split(game, " ") |> List.last |> String.to_integer
    draws = draws |> String.split("; ") |> Enum.map(&parse_draw/1)

    %Game{number: game_number, draws: draws}
  end

  def parse_draw(draw) do
    draw |> String.split(", ") |> Enum.map(&parse_cube/1)
  end

  def parse_cube(cube) do
    [count, color] = String.split(cube, " ")
    %Cube{color: color, count: String.to_integer(count)}
  end
end

defmodule Main do
  def analyse_game(game, given_red, given_green, given_blue) do
    count_cubes_of_color = fn color, draw ->
      Enum.reduce(draw, 0, fn cube, acc ->
        if cube.color == color do
          cube.count
        else
          acc
        end
      end)
    end

    red_cubes = Enum.map(game.draws, &count_cubes_of_color.("red", &1))
    blue_cubes = Enum.map(game.draws, &count_cubes_of_color.("blue", &1))
    green_cubes = Enum.map(game.draws, &count_cubes_of_color.("green", &1))

    min_red = Enum.max(red_cubes)
    min_blue = Enum.max(blue_cubes)
    min_green = Enum.max(green_cubes)

    if min_red <= given_red && min_blue <= given_blue && min_green <= given_green do
      IO.puts("Game #{game.number} is possible")
      game.number
    else
      IO.puts("Game #{game.number} is impossible")
      0
    end
  end

  def main() do
    lines = Loader.read_lines("input.txt")

    given_red = 12
    given_green = 13
    given_blue = 14

    games = Enum.map(lines, &Parser.parse_line/1)
    sum = Enum.reduce(games, 0, fn game, acc ->
      acc + analyse_game(game, given_red, given_green, given_blue)
    end)
    IO.puts("Sum: #{sum}")
  end
end

Main.main()
