defmodule Day11.Day11 do
  use ExUnit.Case

  def run() do
    galaxies = Day11.Galaxies.parse_galaxies(File.read!("lib/day11/input.txt"))
    expansion_spaces = Day11.Galaxies.find_expansion_spaces(galaxies)

    galaxies_pairs =
      galaxies
      |> Day11.Galaxies.galaxy_positions()
      |> Day11.Galaxies.galaxies_pairs()

    shortest_distances_sum =
      galaxies_pairs
      |> Enum.map(fn pair -> Day11.Galaxies.shortest_distance(pair, expansion_spaces) end)
      |> Enum.sum()

    IO.puts("Shortest distances sum: #{shortest_distances_sum}")
    assert shortest_distances_sum == 9_724_940

    shortest_distances_sum =
      galaxies_pairs
      |> Enum.map(fn pair ->
        Day11.Galaxies.shortest_distance(pair, expansion_spaces, 1_000_000)
      end)
      |> Enum.sum()

    IO.puts("Shortest distances sum / expansion factor = 10e6: #{shortest_distances_sum}")
    assert shortest_distances_sum == 569_052_586_852
  end
end
