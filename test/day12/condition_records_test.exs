defmodule Day12.ConditionRecordsTest do
  use ExUnit.Case, async: true

  import Day12.ConditionRecords

  @test_input """
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
  """

  test "parse conditions records" do
    assert parse_condition_records(@test_input) == [
             %{record: "???.###", damaged: [1, 1, 3]},
             %{record: ".??..??...?##.", damaged: [1, 1, 3]},
             %{record: "?#?#?#?#?#?#?#?", damaged: [1, 3, 1, 6]},
             %{record: "????.#...#...", damaged: [4, 1, 1]},
             %{record: "????.######..#####.", damaged: [1, 6, 5]},
             %{record: "?###????????", damaged: [3, 2, 1]}
           ]
  end

  test "damaged groups" do
    assert damaged_groups("#.#.###") == [1, 1, 3]
    assert damaged_groups(".#....#...###.") == [1, 1, 3]
  end

  test "record match damaged" do
    assert record_match_damaged?("#.#.###", [1, 1, 3])
    assert !record_match_damaged?(".##.###", [1, 1, 3])
  end

  test "possible arrangements" do
    assert possible_arrangements(%{record: "???.###", damaged: [1, 1, 3]}) == ["#.#.###"]

    assert possible_arrangements(%{record: ".??..??...?##.", damaged: [1, 1, 3]}) == [
             ".#...#....###.",
             ".#....#...###.",
             "..#..#....###.",
             "..#...#...###."
           ]

    assert possible_arrangements(%{record: "?###????????", damaged: [3, 2, 1]}) == [
             ".###.##.#...",
             ".###.##..#..",
             ".###.##...#.",
             ".###.##....#",
             ".###..##.#..",
             ".###..##..#.",
             ".###..##...#",
             ".###...##.#.",
             ".###...##..#",
             ".###....##.#"
           ]

    assert @test_input
           |> parse_condition_records()
           |> Enum.map(fn record ->
             count_possible_arrangements(record.record, record.damaged)
           end) == [1, 4, 1, 1, 4, 10]
  end

  test "unfolded arrangements" do
    assert @test_input
           |> parse_condition_records()
           |> Enum.map(&unfold_record/1)
           |> Enum.map(fn %{record: record, damaged: damaged} ->
             count_possible_arrangements(record, damaged)
           end) == [
             1,
             16384,
             1,
             16,
             2500,
             506_250
           ]
  end
end
