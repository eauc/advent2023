defmodule Day12.Day12 do
  use ExUnit.Case

  def run() do
    records =
      File.read!("lib/day12/input.txt")
      |> Day12.ConditionRecords.parse_condition_records()

    arrangements_sum =
      records
      |> Enum.map(fn %{record: record, damaged: damaged} ->
        Day12.ConditionRecords.count_possible_arrangements(record, damaged)
      end)
      |> Enum.sum()

    IO.puts("arrangements sum: #{arrangements_sum}")
    assert arrangements_sum == 7032

    unfolded_arrangements_sum =
      records
      |> Enum.map(&Day12.ConditionRecords.unfold_record/1)
      |> Enum.map(fn %{record: record, damaged: damaged} ->
        Day12.ConditionRecords.count_possible_arrangements(record, damaged)
      end)
      |> Enum.sum()

    IO.puts("unfolded arrangements sum: #{unfolded_arrangements_sum}")
    assert unfolded_arrangements_sum == 1_493_340_882_140
  end
end
