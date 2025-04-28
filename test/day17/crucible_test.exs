defmodule Day17.CrucibleTest do
  use ExUnit.Case, async: true

  import Day17.Crucible

  @test_input """
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
  """

  test "parse city map" do
    assert parse_city_map(@test_input) == [
             [2, 4, 1, 3, 4, 3, 2, 3, 1, 1, 3, 2, 3],
             [3, 2, 1, 5, 4, 5, 3, 5, 3, 5, 6, 2, 3],
             [3, 2, 5, 5, 2, 4, 5, 6, 5, 4, 2, 5, 4],
             [3, 4, 4, 6, 5, 8, 5, 8, 4, 5, 4, 5, 2],
             [4, 5, 4, 6, 6, 5, 7, 8, 6, 7, 5, 3, 6],
             [1, 4, 3, 8, 5, 9, 8, 7, 9, 8, 4, 5, 4],
             [4, 4, 5, 7, 8, 7, 6, 9, 8, 7, 7, 6, 6],
             [3, 6, 3, 7, 8, 7, 7, 9, 7, 9, 6, 5, 3],
             [4, 6, 5, 4, 9, 6, 7, 9, 8, 6, 8, 8, 7],
             [4, 5, 6, 4, 6, 7, 9, 9, 8, 6, 4, 5, 3],
             [1, 2, 2, 4, 6, 8, 6, 8, 6, 5, 5, 6, 3],
             [2, 5, 4, 6, 5, 4, 8, 8, 8, 7, 7, 3, 5],
             [4, 3, 2, 2, 6, 7, 4, 6, 5, 5, 5, 3, 3]
           ]
  end

  test "next positions for simple crucible" do
    assert next_positions_simple([{nil, 1, 2}], {10, 5}) == [
             [{:right, 2, 2}, {nil, 1, 2}],
             [{:left, 0, 2}, {nil, 1, 2}],
             [{:down, 1, 3}, {nil, 1, 2}],
             [{:up, 1, 1}, {nil, 1, 2}]
           ]

    assert next_positions_simple([{nil, 0, 2}], {10, 5}) == [
             [{:right, 1, 2}, {nil, 0, 2}],
             [{:down, 0, 3}, {nil, 0, 2}],
             [{:up, 0, 1}, {nil, 0, 2}]
           ]

    assert next_positions_simple([{nil, 9, 2}], {10, 5}) == [
             [{:left, 8, 2}, {nil, 9, 2}],
             [{:down, 9, 3}, {nil, 9, 2}],
             [{:up, 9, 1}, {nil, 9, 2}]
           ]

    assert next_positions_simple([{nil, 1, 0}], {10, 5}) == [
             [{:right, 2, 0}, {nil, 1, 0}],
             [{:left, 0, 0}, {nil, 1, 0}],
             [{:down, 1, 1}, {nil, 1, 0}]
           ]

    assert next_positions_simple([{nil, 1, 4}], {10, 5}) == [
             [{:right, 2, 4}, {nil, 1, 4}],
             [{:left, 0, 4}, {nil, 1, 4}],
             [{:up, 1, 3}, {nil, 1, 4}]
           ]

    assert next_positions_simple([{:right, 1, 2}], {10, 5}) == [
             [{:right, 2, 2}, {:right, 1, 2}],
             [{:down, 1, 3}, {:right, 1, 2}],
             [{:up, 1, 1}, {:right, 1, 2}]
           ]

    assert next_positions_simple([{:left, 1, 2}], {10, 5}) == [
             [{:left, 0, 2}, {:left, 1, 2}],
             [{:down, 1, 3}, {:left, 1, 2}],
             [{:up, 1, 1}, {:left, 1, 2}]
           ]

    assert next_positions_simple([{:up, 1, 2}], {10, 5}) == [
             [{:right, 2, 2}, {:up, 1, 2}],
             [{:left, 0, 2}, {:up, 1, 2}],
             [{:up, 1, 1}, {:up, 1, 2}]
           ]

    assert next_positions_simple([{:down, 1, 2}], {10, 5}) == [
             [{:right, 2, 2}, {:down, 1, 2}],
             [{:left, 0, 2}, {:down, 1, 2}],
             [{:down, 1, 3}, {:down, 1, 2}]
           ]

    assert next_positions_simple([{:down, 1, 3}, {:down, 1, 2}], {10, 5}) == [
             [{:right, 2, 3}, {:down, 1, 3}, {:down, 1, 2}],
             [{:left, 0, 3}, {:down, 1, 3}, {:down, 1, 2}],
             [{:down, 1, 4}, {:down, 1, 3}, {:down, 1, 2}]
           ]

    assert next_positions_simple([{:down, 1, 3}, {:left, 1, 2}, {:down, 1, 1}], {10, 5}) == [
             [{:right, 2, 3}, {:down, 1, 3}, {:left, 1, 2}],
             [{:left, 0, 3}, {:down, 1, 3}, {:left, 1, 2}],
             [{:down, 1, 4}, {:down, 1, 3}, {:left, 1, 2}]
           ]

    assert next_positions_simple([{:down, 1, 3}, {:down, 1, 2}, {:down, 1, 1}], {10, 5}) == [
             [{:right, 2, 3}, {:down, 1, 3}, {:down, 1, 2}],
             [{:left, 0, 3}, {:down, 1, 3}, {:down, 1, 2}]
           ]
  end

  test "next positions for an ultra crucible" do
    assert next_positions_ultra([{:right, 1, 2}], {10, 5}) == [
             [{:right, 2, 2}, {:right, 1, 2}]
           ]

    assert next_positions_ultra([{:right, 1, 2}, {:right, 1, 2}], {10, 5}) == [
             [{:right, 2, 2}, {:right, 1, 2}, {:right, 1, 2}]
           ]

    assert next_positions_ultra([{:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}], {10, 5}) == [
             [{:right, 2, 2}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}]
           ]

    assert next_positions_ultra(
             [{:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}],
             {10, 5}
           ) == [
             [{:right, 2, 2}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}],
             [{:down, 1, 3}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}],
             [{:up, 1, 1}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}, {:right, 1, 2}]
           ]

    assert next_positions_ultra(
             [
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2}
             ],
             {10, 5}
           ) == [
             [
               {:down, 1, 3},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2}
             ],
             [
               {:up, 1, 1},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2},
               {:right, 1, 2}
             ]
           ]
  end

  test "minimum heat loss path" do
    city_map = parse_city_map(@test_input)
    assert minimum_heat_loss_path_cost(city_map) == 102
  end

  test "minimum heat loss path with ultra crucibles" do
    city_map = parse_city_map(@test_input)
    assert minimum_heat_loss_path_cost_ultra(city_map) == 94
  end
end
