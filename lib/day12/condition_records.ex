defmodule Day12.ConditionRecords do
  @moduledoc """
  Many of the springs have fallen into disrepair, so they're not actually sure which springs would even be safe to use! Worse yet, their condition records of which springs are damaged (your puzzle input) are also damaged! You'll need to help them repair the damaged records.

  In the giant field just outside, the springs are arranged into rows. For each row, the condition records show every spring and whether it is operational (.) or damaged (#). This is the part of the condition records that is itself damaged; for some springs, it is simply unknown (?) whether the spring is operational or damaged.

  However, the engineer that produced the condition records also duplicated some of this information in a different format! After the list of springs for a given row, the size of each contiguous group of damaged springs is listed in the order those groups appear in the row. This list always accounts for every damaged spring, and each number is the entire size of its contiguous group (that is, groups are always separated by at least one operational spring: #### would always be 4, never 2,2).

  So, condition records with no unknown spring conditions might look like this:

  ```
  #.#.### 1,1,3
  .#...#....###. 1,1,3
  .#.###.#.###### 1,3,1,6
  ####.#...#... 4,1,1
  #....######..#####. 1,6,5
  .###.##....# 3,2,1
  ```
  However, the condition records are partially damaged; some of the springs' conditions are actually unknown (?). For example:

  ```
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
  ```
  Equipped with this information, it is your job to figure out how many different arrangements of operational and broken springs fit the given criteria in each row.

  In the first line (???.### 1,1,3), there is exactly one way separate groups of one, one, and three broken springs (in that order) can appear in that row: the first three unknown springs must be broken, then operational, then broken (#.#), making the whole row #.#.###.

  The second line is more interesting: .??..??...?##. 1,1,3 could be a total of four different arrangements. The last ? must always be broken (to satisfy the final contiguous group of three broken springs), and each ?? must hide exactly one of the two broken springs. (Neither ?? could be both broken springs or they would form a single contiguous group of two; if that were true, the numbers afterward would have been 2,3 instead.) Since each ?? can either be #. or .#, there are four possible arrangements of springs.

  The last line is actually consistent with ten different arrangements! Because the first number is 3, the first and second ? must both be . (if either were #, the first number would have to be 4 or higher). However, the remaining run of unknown spring conditions have many different ways they could hold groups of two and one broken springs:

  ```
  ?###???????? 3,2,1
  .###.##.#...
  .###.##..#..
  .###.##...#.
  .###.##....#
  .###..##.#..
  .###..##..#.
  .###..##...#
  .###...##.#.
  .###...##..#
  .###....##.#
  ```
  In this example, the number of possible arrangements for each row is:

  - `???.### 1,1,3` - 1 arrangement
  - `.??..??...?##. 1,1,3` - 4 arrangements
  - `?#?#?#?#?#?#?#? 1,3,1,6` - 1 arrangement
  - `????.#...#... 4,1,1` - 1 arrangement
  - `????.######..#####. 1,6,5` - 4 arrangements
  - `?###???????? 3,2,1` - 10 arrangements
  Adding all of the possible arrangement counts together produces a total of 21 arrangements.

  When you examine the records, you discover that they were actually folded up this whole time!

  To unfold the records, on each row, replace the list of spring conditions with five copies of itself (separated by ?) and replace the list of contiguous groups of damaged springs with five copies of itself (separated by ,).

  So, this row:

  ```
  .# 1
  ```
  Would become:

  ```
  .#?.#?.#?.#?.# 1,1,1,1,1
  ```
  The first line of the above example would become:

  ```
  ???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3
  ```
  In the above example, after unfolding, the number of possible arrangements for some rows is now much larger:

  - `???.### 1,1,3` - 1 arrangement
  - `.??..??...?##. 1,1,3` - 16384 arrangements
  - `?#?#?#?#?#?#?#? 1,3,1,6` - 1 arrangement
  - `????.#...#... 4,1,1` - 16 arrangements
  - `????.######..#####. 1,6,5` - 2500 arrangements
  - `?###???????? 3,2,1` - 506250 arrangements
  After unfolding, adding all of the possible arrangement counts together produces 525152.
  """
  use Memoize

  def parse_condition_records(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [record_str, damaged_str] = line |> String.split(" ", parts: 2, trim: true)
      record = record_str
      damaged = damaged_str |> String.split(",") |> Enum.map(&String.to_integer/1)
      %{record: record, damaged: damaged}
    end)
  end

  @doc """
  Unfolds one record.

  To unfold the records, on each row, replace the list of spring conditions with five copies of itself (separated by ?)
  and replace the list of contiguous groups of damaged springs with five copies of itself (separated by ,).
  """
  def unfold_record(%{record: record, damaged: damaged}) do
    %{
      record: Enum.join(Enum.map(1..5, fn _ -> record end), "?"),
      damaged: Enum.flat_map(1..5, fn _ -> damaged end)
    }
  end

  @doc """
  Returns the damaged groups sizes of a complete record.
  """
  def damaged_groups(record) do
    record
    |> String.split(".", trim: true)
    |> Enum.map(&String.length/1)
  end

  @doc """
  Checks if a record matches the damaged groups sizes.
  """
  def record_match_damaged?(record, damaged) do
    damaged_groups(record) == damaged
  end

  @doc """
  Calculates all possible record arrangements matching a damaged groups sizes.
  """
  def possible_arrangements(%{record: record, damaged: damaged}) do
    # IO.inspect({record, damaged})

    cond do
      !String.contains?(record, "?") ->
        if record_match_damaged?(record, damaged), do: [record], else: []

      true ->
        cond do
          String.length(String.replace(record, ".", "")) == Enum.sum(damaged) ->
            # IO.puts("all unknown must be damaged")
            [String.replace(record, "?", "#")]

          String.length(String.replace(record, ["?", "."], "")) == Enum.sum(damaged) ->
            # IO.puts("all unknown must be undamaged")
            [String.replace(record, "?", ".")]

          true ->
            [
              String.replace(record, "?", "#", global: false),
              String.replace(record, "?", ".", global: false)
            ]
        end
        |> Enum.flat_map(fn new_record ->
          possible_arrangements(%{record: new_record, damaged: damaged})
        end)
    end
  end

  @doc """
  Counts all possible record arrangements matching a damaged groups sizes.

  - if there are no damaged groups left, the arrangement is valid only if there are no damaged states left in the record.
  - if the record is empty, the arrangement is valid only if there are no damaged groups left.
  - if the record starts with a (possible) operational state, skip it and count the number of arrangements for the rest of the records.
  - if the record starts with a (possible) damaged state, checks if the record can start with as many damaged states as the first damaged group size
    - if yes, then returns the number of arrangements for the rest of the record after removing the first damaged group size + 1 state, and the rest of the damaged groups.
  """
  def count_possible_arrangements(record, damaged)
  defmemo count_possible_arrangements(record, damaged) do
    # IO.inspect({record, damaged})

    cond do
      damaged == [] ->
        if String.contains?(record, "#"), do: 0, else: 1

      String.length(record) == 0 ->
        if damaged == [], do: 1, else: 0

      true ->
        if String.first(record) == "." or String.first(record) == "?" do
          count_possible_arrangements(String.slice(record, 1, String.length(record)), damaged)
        else
          0
        end +
          if String.first(record) == "#" or String.first(record) == "?" do
            [dcount | _] = damaged
            leading_record = String.slice(record, 0, dcount)

            if String.length(leading_record) == dcount and !String.contains?(leading_record, ".") and
                 (String.length(record) == dcount or String.at(record, dcount) != "#") do
              count_possible_arrangements(
                String.slice(record, dcount + 1, String.length(record)),
                tl(damaged)
              )
            else
              0
            end
          else
            0
          end
    end
  end
end
