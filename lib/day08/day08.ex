defmodule Day08.Day08 do
  use ExUnit.Case

  def run() do
    desert_maps =
      File.read!("lib/day08/input.txt")
      |> Day08.DesertMaps.parse_desert_maps()

    steps = Day08.DesertMaps.follow_directions(desert_maps)
    IO.puts("# Steps: #{Enum.count(steps)}")
    assert Enum.count(steps) == 21409

    ghosts_steps = Day08.DesertMaps.follow_directions_as_ghosts(desert_maps)
    IO.puts("# Ghosts Steps: #{ghosts_steps}")
    assert ghosts_steps == 21_165_830_176_709
  end
end
