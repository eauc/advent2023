defmodule Day17.Day17 do
  use ExUnit.Case

  def run() do
    city_map =
      File.read!("lib/day17/input.txt")
      |> Day17.Crucible.parse_city_map()

    min_cost = Day17.Crucible.minimum_heat_loss_path_cost(city_map)
    IO.puts("Minimum heat loss path cost: #{min_cost}")
    assert min_cost == 1023

    min_cost_ultra = Day17.Crucible.minimum_heat_loss_path_cost_ultra(city_map)
    IO.puts("Minimum heat loss path cost with ultra crucibles: #{min_cost_ultra}")
    assert min_cost_ultra == 1165
  end
end
