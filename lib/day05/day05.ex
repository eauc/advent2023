defmodule Day05.Day05 do
  use ExUnit.Case

  def run() do
    {seeds, seed_rngs, alamanac} =
      File.read!("lib/day05/input.txt")
      |> String.split("\n", trim: true)
      |> Day05.Almanac.parse_almanac()

    locations = Day05.Almanac.translate_seeds_to_locations(seeds, alamanac)
    IO.puts("Lowest location from individual seeds: #{Enum.min(locations)}")
    assert Enum.min(locations) == 88_151_870

    location_rngs = Day05.Almanac.translate_seed_rngs_to_locations(seed_rngs, alamanac)
    min_location = location_rngs |> Enum.map(fn start.._//_ -> start end) |> Enum.min()
    IO.puts("Lowest location from seed ranges: #{min_location}")
    assert min_location == 2_008_785
  end
end
