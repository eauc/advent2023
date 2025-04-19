defmodule Day06.Day06 do
  use ExUnit.Case

  def run() do
    product =
      File.read!("lib/day06/input.txt")
      |> Day06.BoatRaces.parse_boat_races()
      |> Enum.map(&Day06.BoatRaces.winning_holding_times_range/1)
      |> Enum.product_by(&Range.size/1)

    IO.puts("Product of number of winning moves: #{product}")

    corrected =
      File.read!("lib/day06/input.txt")
      |> Day06.BoatRaces.parse_boat_races_corrected()
      |> Day06.BoatRaces.winning_holding_times_range()
      |> Range.size()

    IO.puts("Number of winning moves: #{corrected}")
  end
end
