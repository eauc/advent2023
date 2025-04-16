defmodule Day01.Day01 do
  use ExUnit.Case

  def run do
    naive_sum =
      File.stream!("lib/day01/input.txt", :line)
      |> Day01.Trebuchet.naive_calibration_value_sum()

    IO.puts(["Naive calibration sum: ", to_string(naive_sum)])
    assert naive_sum == 55029

    sum =
      File.stream!("lib/day01/input.txt", :line)
      |> Day01.Trebuchet.calibration_value_sum()

    IO.puts(["Calibration sum: ", to_string(sum)])
    assert sum == 55686
  end
end
