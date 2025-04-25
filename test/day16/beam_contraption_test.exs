defmodule Day16.BeamContraptionTest do
  use ExUnit.Case, async: true

  import Day16.BeamContraption

  @test_input """
  .|...\\....
  |.-.\\.....
  .....|-...
  ........|.
  ..........
  .........\\
  ..../.\\\\..
  .-.-/..|..
  .|....-|.\\
  ..//.|....
  """

  test "parse contraption map" do
    assert parse_contraption_map(@test_input) == [
             ".|...\\....",
             "|.-.\\.....",
             ".....|-...",
             "........|.",
             "..........",
             ".........\\",
             "..../.\\\\..",
             ".-.-/..|..",
             ".|....-|.\\",
             "..//.|...."
           ]
  end

  test "propagate beam" do
    map = parse_contraption_map(@test_input)

    beam_path = propagate_beam(map)

    # IO.puts(draw_beam_path(map, beam_path))

    assert count_energized(beam_path) == 46
  end

  test "find maximum energized" do
    map = parse_contraption_map(@test_input)

    assert find_maximum_energized(map) == 51
  end
end
