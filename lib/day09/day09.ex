defmodule Day09.Day09 do
  use ExUnit.Case

  def run do
    reports =
      File.read!("./lib/day09/input.txt")
      |> Day09.OasisReport.parse_oasis_reports()

    next_values_sum =
      Enum.map(reports, fn report ->
        report
        |> Day09.OasisReport.report_derivations()
        |> Day09.OasisReport.predict_next_value()
      end)
      |> Enum.sum()

    IO.puts("Next values sum: #{next_values_sum}")
    assert next_values_sum == 1_725_987_467

    previous_values_sum =
      Enum.map(reports, fn report ->
        report
        |> Day09.OasisReport.report_derivations()
        |> Day09.OasisReport.predict_previous_value()
      end)
      |> Enum.sum()

    IO.puts("Previous values sum: #{previous_values_sum}")
    assert previous_values_sum == 971
  end
end
