defmodule Day03.Day03 do
  use ExUnit.Case

  def run do
    engine_map =
      File.stream!("lib/day03/input.txt", :line)

    part_numbers_sum =
      engine_map
      |> Day03.GearRatios.parse_part_numbers()
      |> Enum.sum_by(& &1.number)

    IO.puts("Sum of the part numbers: #{part_numbers_sum}")
    assert part_numbers_sum == 517_021

    gear_ratios_sum =
      engine_map
      |> Day03.GearRatios.parse_gears()
      |> Stream.map(&Day03.GearRatios.gear_ratio/1)
      |> Enum.sum()

    IO.puts("Sum of the gear ratios: #{gear_ratios_sum}")
    assert gear_ratios_sum == 81_296_995
  end
end
