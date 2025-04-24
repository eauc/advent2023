defmodule Day14.ParabolicReflectorTest do
  use ExUnit.Case, async: true

  import Day14.ParabolicReflector

  @test_input """
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  """

  test "parse platform map" do
    assert parse_platform_map(@test_input) == [
             "O....#....",
             "O.OO#....#",
             ".....##...",
             "OO.#O....O",
             ".O.....O#.",
             "O.#..O.#.#",
             "..O..#O..O",
             ".......O..",
             "#....###..",
             "#OO..#...."
           ]
  end

  test "tilt north" do
    assert parse_platform_map(@test_input)
           |> tilt_north() == [
             "OOOO.#.O..",
             "OO..#....#",
             "OO..O##..O",
             "O..#.OO...",
             "........#.",
             "..#....#.#",
             "..O..#.O.O",
             "..O.......",
             "#....###..",
             "#....#...."
           ]
  end

  test "cycle" do
    assert parse_platform_map(@test_input)
           |> cycle() == [
             ".....#....",
             "....#...O#",
             "...OO##...",
             ".OO#......",
             ".....OOO#.",
             ".O#...O#.#",
             "....O#....",
             "......OOOO",
             "#...O###..",
             "#..OO#...."
           ]

    assert parse_platform_map(@test_input)
           |> cycle()
           |> cycle() == [
             ".....#....",
             "....#...O#",
             ".....##...",
             "..O#......",
             ".....OOO#.",
             ".O#...O#.#",
             "....O#...O",
             ".......OOO",
             "#..OO###..",
             "#.OOO#...O"
           ]

    assert parse_platform_map(@test_input)
           |> cycle()
           |> cycle()
           |> cycle() == [
             ".....#....",
             "....#...O#",
             ".....##...",
             "..O#......",
             ".....OOO#.",
             ".O#...O#.#",
             "....O#...O",
             ".......OOO",
             "#...O###.O",
             "#.OOO#...O"
           ]
  end

  test "total load" do
    assert parse_platform_map(@test_input)
           |> tilt_north()
           |> total_load() == 136
  end

  test "total load after 1e9 cycles" do
    assert parse_platform_map(@test_input)
           |> cycle(100000)
           |> total_load() == 65
  end
end
