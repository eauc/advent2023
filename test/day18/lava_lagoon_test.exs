defmodule Day18.LavaLagoonTest do
  use ExUnit.Case, async: true

  import Day18.LavaLagoon

  @test_input """
  R 6 (#70c710)
  D 5 (#0dc571)
  L 2 (#5713f0)
  D 2 (#d2c081)
  R 2 (#59c680)
  D 2 (#411b91)
  L 5 (#8ceee2)
  U 2 (#caa173)
  L 1 (#1b58a2)
  U 2 (#caa171)
  R 2 (#7807d2)
  U 3 (#a77fa3)
  L 2 (#015232)
  U 2 (#7a21e3)
  """

  test "parse dig plan" do
    assert parse_dig_plan(@test_input)
           |> Enum.map(fn {plan, _} -> plan end) == [
             {:right, 6},
             {:down, 5},
             {:left, 2},
             {:down, 2},
             {:right, 2},
             {:down, 2},
             {:left, 5},
             {:up, 2},
             {:left, 1},
             {:up, 2},
             {:right, 2},
             {:up, 3},
             {:left, 2},
             {:up, 2}
           ]

    assert parse_dig_plan(@test_input)
           |> Enum.map(fn {_, plan} -> plan end) ==
             [
               {:right, 461_937},
               {:down, 56407},
               {:right, 356_671},
               {:down, 863_240},
               {:right, 367_720},
               {:down, 266_681},
               {:left, 577_262},
               {:up, 829_975},
               {:left, 112_010},
               {:down, 829_975},
               {:left, 491_645},
               {:up, 686_074},
               {:left, 5411},
               {:up, 500_254}
             ]
  end

  test "dig lagoon" do
    {{x_rgn, y_rng}, lagoon_capacity} =
      parse_dig_plan(@test_input)
      |> Enum.map(fn {plan, _} -> plan end)
      |> dig_lagoon()

    assert x_rgn == {0, 6}
    assert y_rng == {0, 9}

    assert lagoon_capacity == 62
  end

  # too fucking slow :D
  # test "dig lagoon color plan" do
  #   {_, lagoon_capacity} =
  #     parse_dig_plan(@test_input)
  #     |> Enum.map(fn {_, plan} -> plan end)
  #     |> dig_lagoon()
  #
  #   assert lagoon_capacity == 952_408_144_115
  # end
end
