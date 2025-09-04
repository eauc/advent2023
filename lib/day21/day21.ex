defmodule Day21.Day21 do
  use ExUnit.Case

  def run() do
    garden_map =
      File.read!("lib/day21/input.txt")
      |> Day21.GardenSteps.parse_garden_map()

    pos_count = Day21.GardenSteps.reachable_positions(64, garden_map) |> MapSet.size()
    IO.puts("Reachable positions: #{pos_count}")
    assert pos_count == 3649

    infinite_reachable_positions_count =
      Day21.GardenSteps.count_reachable_positions_infinite(26_501_365, garden_map)

    IO.puts("Infinite reachable positions: #{infinite_reachable_positions_count}")
    assert infinite_reachable_positions_count == 612_941_134_797_232
  end
end
