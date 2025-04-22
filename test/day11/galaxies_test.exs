defmodule Day11.GalaxiesTest do
  use ExUnit.Case, async: true

  import Day11.Galaxies

  @test_input """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  test "parse galaxies" do
    assert parse_galaxies(@test_input) == [
             ~c"...#......",
             ~c".......#..",
             ~c"#.........",
             ~c"..........",
             ~c"......#...",
             ~c".#........",
             ~c".........#",
             ~c"..........",
             ~c".......#..",
             ~c"#...#....."
           ]
  end

  test "find expansion spaces" do
    assert parse_galaxies(@test_input)
           |> find_expansion_spaces() == %{
             cols: [2, 5, 8],
             rows: [3, 7]
           }
  end

  test "galaxy positions" do
    assert parse_galaxies(@test_input)
           |> galaxy_positions() == [
             {0, 3},
             {1, 7},
             {2, 0},
             {4, 6},
             {5, 1},
             {6, 9},
             {8, 7},
             {9, 0},
             {9, 4}
           ]
  end

  test "galaxies pairs" do
    assert parse_galaxies(@test_input)
           |> galaxy_positions()
           |> galaxies_pairs() == [
             {{9, 0}, {9, 4}},
             {{8, 7}, {9, 0}},
             {{8, 7}, {9, 4}},
             {{6, 9}, {8, 7}},
             {{6, 9}, {9, 0}},
             {{6, 9}, {9, 4}},
             {{5, 1}, {6, 9}},
             {{5, 1}, {8, 7}},
             {{5, 1}, {9, 0}},
             {{5, 1}, {9, 4}},
             {{4, 6}, {5, 1}},
             {{4, 6}, {6, 9}},
             {{4, 6}, {8, 7}},
             {{4, 6}, {9, 0}},
             {{4, 6}, {9, 4}},
             {{2, 0}, {4, 6}},
             {{2, 0}, {5, 1}},
             {{2, 0}, {6, 9}},
             {{2, 0}, {8, 7}},
             {{2, 0}, {9, 0}},
             {{2, 0}, {9, 4}},
             {{1, 7}, {2, 0}},
             {{1, 7}, {4, 6}},
             {{1, 7}, {5, 1}},
             {{1, 7}, {6, 9}},
             {{1, 7}, {8, 7}},
             {{1, 7}, {9, 0}},
             {{1, 7}, {9, 4}},
             {{0, 3}, {1, 7}},
             {{0, 3}, {2, 0}},
             {{0, 3}, {4, 6}},
             {{0, 3}, {5, 1}},
             {{0, 3}, {6, 9}},
             {{0, 3}, {8, 7}},
             {{0, 3}, {9, 0}},
             {{0, 3}, {9, 4}}
           ]

    assert parse_galaxies(@test_input)
           |> galaxy_positions()
           |> galaxies_pairs()
           |> Enum.count() == 36
  end

  test "shortest distance between pair" do
    galaxies = parse_galaxies(@test_input)
    expansion_spaces = find_expansion_spaces(galaxies)

    assert galaxies
           |> galaxy_positions()
           |> galaxies_pairs()
           |> Enum.map(fn pair -> {pair, shortest_distance(pair, expansion_spaces)} end)
           |> Enum.into(%{}) == %{
             {{1, 7}, {9, 4}} => 14,
             {{4, 6}, {8, 7}} => 6,
             {{1, 7}, {4, 6}} => 5,
             {{9, 0}, {9, 4}} => 5,
             {{5, 1}, {9, 4}} => 9,
             {{1, 7}, {2, 0}} => 10,
             {{1, 7}, {9, 0}} => 19,
             {{1, 7}, {5, 1}} => 13,
             {{0, 3}, {8, 7}} => 15,
             {{5, 1}, {6, 9}} => 12,
             {{2, 0}, {5, 1}} => 5,
             {{2, 0}, {9, 4}} => 14,
             {{6, 9}, {8, 7}} => 6,
             {{0, 3}, {9, 0}} => 15,
             {{0, 3}, {5, 1}} => 9,
             {{5, 1}, {9, 0}} => 6,
             {{8, 7}, {9, 0}} => 10,
             {{1, 7}, {8, 7}} => 9,
             {{0, 3}, {6, 9}} => 15,
             {{2, 0}, {8, 7}} => 17,
             {{6, 9}, {9, 0}} => 16,
             {{4, 6}, {6, 9}} => 6,
             {{4, 6}, {9, 4}} => 9,
             {{2, 0}, {6, 9}} => 17,
             {{2, 0}, {4, 6}} => 11,
             {{2, 0}, {9, 0}} => 9,
             {{6, 9}, {9, 4}} => 11,
             {{0, 3}, {1, 7}} => 6,
             {{4, 6}, {9, 0}} => 14,
             {{4, 6}, {5, 1}} => 8,
             {{0, 3}, {4, 6}} => 9,
             {{5, 1}, {8, 7}} => 12,
             {{8, 7}, {9, 4}} => 5,
             {{1, 7}, {6, 9}} => 9,
             {{0, 3}, {9, 4}} => 12,
             {{0, 3}, {2, 0}} => 6
           }

    assert galaxies
           |> galaxy_positions()
           |> galaxies_pairs()
           |> Enum.map(fn pair -> shortest_distance(pair, expansion_spaces) end)
           |> Enum.sum() == 374

    assert galaxies
           |> galaxy_positions()
           |> galaxies_pairs()
           |> Enum.map(fn pair -> shortest_distance(pair, expansion_spaces, 10) end)
           |> Enum.sum() == 1030

    assert galaxies
           |> galaxy_positions()
           |> galaxies_pairs()
           |> Enum.map(fn pair -> shortest_distance(pair, expansion_spaces, 100) end)
           |> Enum.sum() == 8410
  end
end
