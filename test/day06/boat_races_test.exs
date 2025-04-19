defmodule Day06.BoatRacesTest do
  use ExUnit.Case

  import Day06.BoatRaces

  @test_input """
  Time:      7  15   30
  Distance:  9  40  200
  """

  test "parse boat races" do
    assert parse_boat_races(@test_input) == [{7, 9}, {15, 40}, {30, 200}]
  end

  test "parse boat races corrected" do
    assert parse_boat_races_corrected(@test_input) == {71530, 940200}
  end

  test "winning holding times range" do
    assert winning_holding_times_range({7, 9}) == 2..5//1
    assert winning_holding_times_range({15, 40}) == 4..11//1
    assert winning_holding_times_range({30, 200}) == 11..19//1

    assert @test_input
           |> parse_boat_races()
           |> Enum.map(&winning_holding_times_range/1)
           |> Enum.product_by(&Range.size/1) == 288

    assert @test_input
           |> parse_boat_races_corrected()
           |> winning_holding_times_range()
           |> Range.size() == 71503
  end
end
