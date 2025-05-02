defmodule Day18.Day18 do
  use ExUnit.Case

  def run() do
    dig_plan =
      File.read!("lib/day18/input.txt")
      |> Day18.LavaLagoon.parse_dig_plan()

    {_, lagoon_capacity} =
      dig_plan
      |> Enum.map(fn {plan, _} -> plan end)
      |> Day18.LavaLagoon.dig_lagoon()

    IO.puts("Lagoon capacity: #{lagoon_capacity}")
    assert lagoon_capacity == 68115

    {_, lagoon_capacity} =
      dig_plan
      |> Enum.map(fn {_, plan} -> plan end)
      |> Day18.LavaLagoon.dig_lagoon()

    IO.puts("Lagoon capacity (color plan): #{lagoon_capacity}")
    assert lagoon_capacity == 68115
  end
end
