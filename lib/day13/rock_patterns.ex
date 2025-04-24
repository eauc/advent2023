defmodule Day13.RockPatterns do
  @moduledoc """
  As you move through the valley of mirrors, you find that several of them have fallen from the large metal frames keeping them in place. The mirrors are extremely flat and shiny, and many of the fallen mirrors have lodged into the ash at strange angles. Because the terrain is all one color, it's hard to tell where it's safe to walk or where you're about to run into a mirror.

  You note down the patterns of ash (.) and rocks (#) that you see as you walk (your puzzle input); perhaps by carefully analyzing these patterns, you can figure out where the mirrors are!

  For example:

  ```
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.
  ```

  ```
  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  ```
  To find the reflection in each pattern, you need to find a perfect reflection across either a horizontal line between two rows or across a vertical line between two columns.

  In the first pattern, the reflection is across a vertical line between two columns; arrows on each of the two columns point at the line between the columns:

  ```
  123456789
      ><
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.
      ><
  123456789
  ```
  In this pattern, the line of reflection is the vertical line between columns 5 and 6. Because the vertical line is not perfectly in the middle of the pattern, part of the pattern (column 1) has nowhere to reflect onto and can be ignored; every other column has a reflected column within the pattern and must match exactly: column 2 matches column 9, column 3 matches 8, 4 matches 7, and 5 matches 6.

  The second pattern reflects across a horizontal line instead:

  ```
  1 #...##..# 1
  2 #....#..# 2
  3 ..##..### 3
  4v#####.##.v4
  5^#####.##.^5
  6 ..##..### 6
  7 #....#..# 7
  ```
  This pattern reflects across the horizontal line between rows 4 and 5. Row 1 would reflect with a hypothetical row 8, but since that's not in the pattern, row 1 doesn't need to match anything. The remaining rows match: row 2 matches row 7, row 3 matches row 6, and row 4 matches row 5.

  To summarize your pattern notes, add up the number of columns to the left of each vertical line of reflection; to that, also add 100 multiplied by the number of rows above each horizontal line of reflection. In the above example, the first pattern's vertical line has 5 columns to its left and the second pattern's horizontal line has 4 rows above it, a total of 405.

  Upon closer inspection, you discover that every mirror has exactly one smudge: exactly one . or # should be the opposite type.

  In each pattern, you'll need to locate and fix the smudge that causes a different reflection line to be valid. (The old reflection line won't necessarily continue being valid after the smudge is fixed.)

  Here's the above example again:

  ```
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.
  ```

  ```
  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  ```
  The first pattern's smudge is in the top-left corner. If the top-left # were instead ., it would have a different, horizontal line of reflection:

  ```
  1 ..##..##. 1
  2 ..#.##.#. 2
  3v##......#v3
  4^##......#^4
  5 ..#.##.#. 5
  6 ..##..##. 6
  7 #.#.##.#. 7
  ```
  With the smudge in the top-left corner repaired, a new horizontal line of reflection between rows 3 and 4 now exists. Row 7 has no corresponding reflected row and can be ignored, but every other row matches exactly: row 1 matches row 6, row 2 matches row 5, and row 3 matches row 4.

  In the second pattern, the smudge can be fixed by changing the fifth symbol on row 2 from . to #:

  ```
  1v#...##..#v1
  2^#...##..#^2
  3 ..##..### 3
  4 #####.##. 4
  5 #####.##. 5
  6 ..##..### 6
  7 #....#..# 7
  ```
  Now, the pattern has a different horizontal line of reflection between rows 1 and 2.

  Summarize your notes as before, but instead use the new different reflection lines. In this example, the first pattern's new horizontal line has 3 rows above it and the second pattern's new horizontal line has 1 row above it, summarizing to the value 400.
  """

  def parse_rock_patterns(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  @doc """
  Finds position of horizontal mirror in rock pattern.

  Returns the number of rows above the mirror, or nil if there is no horizontal reflection.
  """
  def find_horizontal_mirror(rock_pattern) do
    1..(length(rock_pattern) - 1)
    |> Enum.find(fn row ->
      leading =
        Enum.take(rock_pattern, row)
        |> Enum.reverse()

      trailing = Enum.drop(rock_pattern, row)

      len = min(length(leading), length(trailing))

      Enum.take(leading, len) == Enum.take(trailing, len)
    end)
  end

  @doc """
  Finds position of vertical mirror in rock pattern.

  Returns the number of rows above the mirror, or nil if there is no vertical reflection.
  """
  def find_vertical_mirror(rock_pattern) do
    rock_pattern
    |> transpose()
    |> find_horizontal_mirror()
  end

  @doc """
  Summarize a list of rock patterns.

  To summarize your pattern notes, add up the number of columns to the left of each vertical line of reflection; 
  to that, also add 100 multiplied by the number of rows above each horizontal line of reflection.
  """
  def summarize(rock_patterns) do
    rock_patterns
    |> Enum.map(fn rock_pattern ->
      {
        find_horizontal_mirror(rock_pattern) || 0,
        find_vertical_mirror(rock_pattern) || 0
      }
    end)
    |> Enum.sum_by(fn {h, v} -> h * 100 + v end)
  end

  @doc """
  Finds position of horizontal mirror in rock pattern, with smudge correction.
  """
  def find_horizontal_mirror_with_smudge_correction(rock_pattern) do
    1..(length(rock_pattern) - 1)
    |> Enum.find(fn row ->
      len = min(row, length(rock_pattern) - row)

      leading =
        Enum.take(rock_pattern, row)
        |> Enum.reverse()
        |> Enum.take(len)

      trailing =
        Enum.drop(rock_pattern, row)
        |> Enum.take(len)

      diff =
        Enum.zip_with(leading, trailing, fn l, r ->
          if l == r do
            0
          else
            0..String.length(l)
            |> Enum.sum_by(fn i ->
              if String.at(l, i) == String.at(r, i) do
                0
              else
                1
              end
            end)
          end
        end)
        |> Enum.sum()

      diff == 1
    end)
  end

  @doc """
  Finds position of horizontal mirror in rock pattern, with smudge correction.
  """
  def find_vertical_mirror_with_smudge_correction(rock_pattern) do
    rock_pattern
    |> transpose()
    |> find_horizontal_mirror_with_smudge_correction()
  end

  @doc """
  Summarize a list of rock patterns, with smudge correction.
  """
  def summarize_with_smudge_correction(rock_patterns) do
    rock_patterns
    |> Enum.map(fn rock_pattern ->
      cond do
        h = find_horizontal_mirror_with_smudge_correction(rock_pattern) -> {h, 0}
        v = find_vertical_mirror_with_smudge_correction(rock_pattern) -> {0, v}
      end
    end)
    |> Enum.sum_by(fn {h, v} -> h * 100 + v end)
  end

  defp transpose(rock_pattern) do
    0..(String.length(hd(rock_pattern)) - 1)
    |> Enum.map(fn col ->
      rock_pattern
      |> Enum.map(&String.at(&1, col))
      |> Enum.join("")
    end)
  end
end
