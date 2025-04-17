defmodule Day03.GearRatios do
  @moduledoc """
  The engine schematic (your puzzle input) consists of a visual representation of the engine.
  There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum.
  (Periods (.) do not count as a symbol.)

  Here is an example engine schematic:
  ```
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  ```
  In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

  The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of multiplying those two numbers together.

  This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.

  Consider the same engine schematic again:
  ```
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  ```
  In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces 467835.
  """

  @doc """
  Parses the part numbers in the engine map.
  """
  def parse_part_numbers(engine_map) do
    engine_map
    |> parse_part_numbers_candidates()
    |> Enum.filter(&part_number?(&1, engine_map))
  end

  @doc """
  Parses the part numbers candidates in the engine map.
  """
  def parse_part_numbers_candidates(engine_map) do
    engine_map
    |> Stream.with_index()
    |> Stream.map(fn {line_str, line} ->
      parse_part_numbers_candidates(line_str, line)
      |> Enum.map(&Map.put(&1, :line, line))
    end)
    |> Enum.concat()
  end

  @doc """
  Parses the part numbers candidates in a line of the engine map.
  """
  def parse_part_numbers_candidates(line_str, line) do
    values_str = Regex.scan(~r/\d+/, line_str)
    values_rng = Regex.scan(~r/\d+/, line_str, return: :index)

    Stream.zip_with(values_str, values_rng, fn [value_str], [{start_col, count}] ->
      %{
        number: String.to_integer(value_str),
        line: line,
        column_rng: start_col..(start_col + count - 1)
      }
    end)
    |> Enum.to_list()
  end

  @doc """
  Any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum
  """
  def part_number?(part_number_candidate, engine_map) do
    {line_rng, column_rng} = adjacent_rng(part_number_candidate)

    line_rng
    |> Enum.map(fn line ->
      Enum.at(engine_map, line, "")
      |> String.slice(column_rng)
      |> String.match?(~r/[^\d.\n]/)
    end)
    |> Enum.any?()
  end

  @doc """
  Parses the gears in the engine map.
  """
  def parse_gears(engine_map) do
    part_numbers = parse_part_numbers(engine_map)

    engine_map
    |> parse_gear_candidates()
    |> Stream.map(&gear?(&1, part_numbers))
    |> Stream.filter(fn {gear?, _} -> gear? end)
    |> Enum.map(fn {_, gear} -> gear end)
  end

  @doc """
  Parses the gear candidates in the engine map.
  """
  def parse_gear_candidates(engine_map) do
    engine_map
    |> Stream.with_index()
    |> Stream.map(fn {line_str, line} ->
      line_str
      |> String.to_charlist()
      |> Stream.with_index()
      |> Stream.filter(fn {char, _} -> char == ?* end)
      |> Stream.map(fn {_, col} -> %{line: line, column_rng: col..col} end)
    end)
    |> Enum.concat()
  end

  @doc """
  A gear is any `*` symbol that is adjacent to exactly two part numbers.
  """
  def gear?(gear_candidate, part_numbers) do
    {line_rng, col_rng} = adjacent_rng(gear_candidate)

    adjacent_part_numbers =
      line_rng
      |> Stream.map(fn line ->
        part_numbers
        |> Stream.filter(fn part_number ->
          part_number.line == line and !Range.disjoint?(part_number.column_rng, col_rng)
        end)
      end)
      |> Enum.concat()

    {
      length(adjacent_part_numbers) == 2,
      Map.put(gear_candidate, :part_numbers, adjacent_part_numbers)
    }
  end

  @doc """
  The gear ratio is the product of the two part numbers in the gear.
  """
  def gear_ratio(gear) do
    gear.part_numbers
    |> Enum.product_by(fn part_number -> part_number.number end)
  end

  defp adjacent_rng(%{line: line, column_rng: first_col..last_col//_}) do
    {max(0, line - 1)..(line + 1), max(0, first_col - 1)..(last_col + 1)}
  end
end
