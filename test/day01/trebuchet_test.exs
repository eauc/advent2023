defmodule Day01.TrebuchetTest do
  use ExUnit.Case, async: true

  import Day01.Trebuchet

  test "naive calibration value" do
    assert naive_calibration_value("1abc2") == 12
    assert naive_calibration_value("pqr3stu8vwx") == 38
    assert naive_calibration_value("a1b2c3d4e5f") == 15
    assert naive_calibration_value("treb7uchet") == 77
  end

  test "calibration value" do
    assert calibration_value("two1nineight") == 28
    assert calibration_value("eightwothree") == 83
    assert calibration_value("abcone2threexyz") == 13
    assert calibration_value("xtwone3four") == 24
    assert calibration_value("4nineeightseven2") == 42
    assert calibration_value("zoneight234") == 14
    assert calibration_value("7pqrstsixteen") == 76
  end

  test "naive calibration value sum" do
    sum =
      Stream.uniq([
        "1abc2",
        "pqr3stu8vwx",
        "a1b2c3d4e5f",
        "treb7uchet"
      ])
      |> naive_calibration_value_sum()

    assert sum == 142
  end

  test "calibration value sum" do
    sum =
      Stream.uniq([
        "two1nine",
        "eightwothree",
        "abcone2threexyz",
        "xtwone3four",
        "4nineeightseven2",
        "zoneight234",
        "7pqrstsixteen"
      ])
      |> calibration_value_sum()

    assert sum == 281
  end
end
