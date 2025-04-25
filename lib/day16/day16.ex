defmodule Day16.Day16 do
  use ExUnit.Case

  def run() do
    map =
      File.read!("lib/day16/input.txt")
      |> Day16.BeamContraption.parse_contraption_map()

    beam_path = Day16.BeamContraption.propagate_beam(map)
    IO.puts(Day16.BeamContraption.draw_beam_path(map, beam_path))

    energized_tiles = Day16.BeamContraption.count_energized(beam_path)
    IO.puts("Energized tiles: #{energized_tiles}")
    assert energized_tiles == 7632

    max_energized = Day16.BeamContraption.find_maximum_energized(map)
    IO.puts("Max energized: #{max_energized}")
    assert max_energized == 8023
  end
end
