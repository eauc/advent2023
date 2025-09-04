defmodule Day21.GardenStepsTest do
  use ExUnit.Case, async: true

  import Day21.GardenSteps

  @test_input """
  ...........
  .....###.#.
  .###.##..#.
  ..#.#...#..
  ....#.#....
  .##..S####.
  .##..#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
  """

  test "parse_garden_map" do
    assert @test_input
           |> parse_garden_map() == %{
             width: 11,
             height: 11,
             rocks:
               MapSet.new([
                 {1, 5},
                 {1, 6},
                 {1, 7},
                 {1, 9},
                 {2, 1},
                 {2, 2},
                 {2, 3},
                 {2, 5},
                 {2, 6},
                 {2, 9},
                 {3, 2},
                 {3, 4},
                 {3, 8},
                 {4, 4},
                 {4, 6},
                 {5, 1},
                 {5, 2},
                 {5, 6},
                 {5, 7},
                 {5, 8},
                 {5, 9},
                 {6, 1},
                 {6, 2},
                 {6, 5},
                 {6, 9},
                 {7, 7},
                 {7, 8},
                 {8, 1},
                 {8, 2},
                 {8, 4},
                 {8, 6},
                 {8, 7},
                 {8, 8},
                 {8, 9},
                 {9, 1},
                 {9, 2},
                 {9, 5},
                 {9, 6},
                 {9, 8},
                 {9, 9}
               ]),
             starting_pos: {5, 5}
           }
  end

  test "neighbours" do
    garden_map =
      @test_input
      |> parse_garden_map()

    %{starting_pos: starting_pos} = garden_map

    assert neighbours(starting_pos, garden_map) == [{4, 5}, {5, 4}]
    assert neighbours({0, 0}, garden_map) == [{1, 0}, {0, 1}]
    assert neighbours({10, 10}, garden_map) == [{9, 10}, {10, 9}]
  end

  test "reachable_positions" do
    garden_map =
      @test_input
      |> parse_garden_map()

    assert reachable_positions(1, garden_map) == MapSet.new([{4, 5}, {5, 4}])
    assert reachable_positions(2, garden_map) == MapSet.new([{3, 5}, {5, 5}, {6, 4}, {5, 3}])

    assert reachable_positions(6, garden_map)
           |> Enum.count() == 16
  end

  test "reachable_positions_infinite" do
    garden_map =
      @test_input
      |> parse_garden_map()

    assert reachable_positions_infinite(6, garden_map) |> Enum.count() == 16
    assert reachable_positions_infinite(10, garden_map) |> Enum.count() == 50
    assert reachable_positions_infinite(50, garden_map) |> Enum.count() == 1594
    assert reachable_positions_infinite(100, garden_map) |> Enum.count() == 6536
    assert reachable_positions_infinite(500, garden_map) |> Enum.count() == 167_004
    # assert reachable_positions_infinite(1000, garden_map) |> Enum.count() == 668_697
    # assert reachable_positions_infinite(5000, garden_map) |> Enum.count() == 16_733_044

    garden_map =
      File.read!("lib/day21/input.txt")
      |> parse_garden_map()

    assert reachable_positions_infinite(65, garden_map) |> Enum.count() == 3832
    assert reachable_positions_infinite(131 + 65, garden_map) |> Enum.count() == 33967
    assert reachable_positions_infinite(131 * 2 + 65, garden_map) |> Enum.count() == 94056
    assert reachable_positions_infinite(131 * 3 + 65, garden_map) |> Enum.count() == 184_099

    assert initial_position_derivations(garden_map) == [
             [0],
             [29954, 29954],
             [90043, 60089, 30135],
             [184_099, 94056, 33967, 3832]
           ]

    assert count_reachable_positions_infinite(26_501_365, garden_map) == 612_941_134_797_232
  end
end
