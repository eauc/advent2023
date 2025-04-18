defmodule Day24.Day24 do
  def run() do
    bounds = {
      200_000_000_000_000,
      400_000_000_000_000
    }

    crosses_count =
    File.stream!("lib/day24/input.txt")
    |> Day24.Hailstones.parse_hailstones()
    |> Day24.Hailstones.hailstones_crosses_within_area(bounds, bounds)
    |> Enum.count()

    IO.puts("nb crosses in area: #{crosses_count}")
  end
end
