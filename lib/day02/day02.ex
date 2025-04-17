defmodule Day02.Day02 do
  use ExUnit.Case

  def run do
    total_cubes = %{red: 12, green: 13, blue: 14}

    games =
      File.stream!("lib/day02/input.txt", :line)
      |> Day02.Cube.parse_games()

    id_sum =
      games
      |> Stream.filter(fn game -> Day02.Cube.game_possible?(game, total_cubes) end)
      |> Enum.sum_by(fn game -> game.id end)

    IO.puts("Sum of the ID of the possible games: #{id_sum}")
    assert id_sum == 1931

    power_sum =
      games
      |> Stream.map(&Day02.Cube.minimum_bag/1)
      |> Stream.map(&Day02.Cube.cubes_set_power/1)
      |> Enum.sum()

    IO.puts("Sum of the powers of all games minimum cubes set: #{power_sum}")
    assert power_sum == 83105
  end
end
