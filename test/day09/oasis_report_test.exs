defmodule Day09.OasisReportTest do
  use ExUnit.Case, async: true

  import Day09.OasisReport

  @test_input """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  test "parse oasis reports" do
    assert parse_oasis_reports(@test_input) == [
             [0, 3, 6, 9, 12, 15],
             [1, 3, 6, 10, 15, 21],
             [10, 13, 16, 21, 30, 45]
           ]
  end

  test "report derivations" do
    assert report_derivations([0, 3, 6, 9, 12, 15]) == [
             [0, 0, 0, 0],
             [3, 3, 3, 3, 3],
             [0, 3, 6, 9, 12, 15]
           ]

    assert report_derivations([1, 3, 6, 10, 15, 21]) == [
             [0, 0, 0],
             [1, 1, 1, 1],
             [2, 3, 4, 5, 6],
             [1, 3, 6, 10, 15, 21]
           ]

    assert report_derivations([10, 13, 16, 21, 30, 45]) == [
             [0, 0],
             [2, 2, 2],
             [0, 2, 4, 6],
             [3, 3, 5, 9, 15],
             [10, 13, 16, 21, 30, 45]
           ]
  end

  test "predict next value from derivations" do
    assert [0, 3, 6, 9, 12, 15]
           |> report_derivations()
           |> predict_next_value() == 18

    assert [1, 3, 6, 10, 15, 21]
           |> report_derivations()
           |> predict_next_value() == 28

    assert [10, 13, 16, 21, 30, 45]
           |> report_derivations()
           |> predict_next_value() == 68
  end

  test "predict previous value from derivations" do
    assert [0, 3, 6, 9, 12, 15]
           |> report_derivations()
           |> predict_previous_value() == -3

    assert [1, 3, 6, 10, 15, 21]
           |> report_derivations()
           |> predict_previous_value() == 0

    assert [10, 13, 16, 21, 30, 45]
           |> report_derivations()
           |> predict_previous_value() == 5
  end
end
