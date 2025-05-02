defmodule Day18.LavaLagoon do
  @moduledoc """
  They aren't sure the lagoon will be big enough; they've asked you to take a look at the dig plan (your puzzle input). For example:

  ```
  R 6 (#70c710)
  D 5 (#0dc571)
  L 2 (#5713f0)
  D 2 (#d2c081)
  R 2 (#59c680)
  D 2 (#411b91)
  L 5 (#8ceee2)
  U 2 (#caa173)
  L 1 (#1b58a2)
  U 2 (#caa171)
  R 2 (#7807d2)
  U 3 (#a77fa3)
  L 2 (#015232)
  U 2 (#7a21e3)
  ```
  The digger starts in a 1 meter cube hole in the ground. They then dig the specified number of meters up (U), down (D), left (L), or right (R), clearing full 1 meter cubes as they go. The directions are given as seen from above, so if "up" were north, then "right" would be east, and so on. Each trench is also listed with the color that the edge of the trench should be painted as an RGB hexadecimal color code.

  When viewed from above, the above example dig plan would result in the following loop of trench (#) having been dug out from otherwise ground-level terrain (.):

  ```
  #######
  #.....#
  ###...#
  ..#...#
  ..#...#
  ###.###
  #...#..
  ##..###
  .#....#
  .######
  ```
  At this point, the trench could contain 38 cubic meters of lava. However, this is just the edge of the lagoon; the next step is to dig out the interior so that it is one meter deep as well:

  ```
  #######
  #######
  #######
  ..#####
  ..#####
  #######
  #####..
  #######
  .######
  .######
  ```
  Now, the lagoon can contain a much more respectable 62 cubic meters of lava. While the interior is dug out, the edges are also painted according to the color codes in the dig plan.

  After a few minutes, someone realizes what happened; someone swapped the color and instruction parameters when producing the dig plan. They don't have time to fix the bug; one of them asks if you can extract the correct instructions from the hexadecimal codes.

  Each hexadecimal code is six hexadecimal digits long. The first five hexadecimal digits encode the distance in meters as a five-digit hexadecimal number. The last hexadecimal digit encodes the direction to dig: 0 means R, 1 means D, 2 means L, and 3 means U.

  So, in the above example, the hexadecimal codes can be converted into the true instructions:

  ```
  #70c710 = R 461937
  #0dc571 = D 56407
  #5713f0 = R 356671
  #d2c081 = D 863240
  #59c680 = R 367720
  #411b91 = D 266681
  #8ceee2 = L 577262
  #caa173 = U 829975
  #1b58a2 = L 112010
  #caa171 = D 829975
  #7807d2 = L 491645
  #a77fa3 = U 686074
  #015232 = L 5411
  #7a21e3 = U 500254
  ```
  Digging out this loop and its interior produces a lagoon that can hold an impressive 952408144115 cubic meters of lava.
  """
  use Memoize
  require Integer

  def parse_dig_plan(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [dir_str, count_str, color_str] = String.split(line, " ", trim: true)

      {color_count_str, color_dir_str} =
        String.replace(color_str, ["(", "#", ")"], "")
        |> String.split_at(5)

      {
        {
          case dir_str do
            "U" -> :up
            "D" -> :down
            "L" -> :left
            "R" -> :right
          end,
          String.to_integer(count_str)
        },
        {
          case color_dir_str do
            "0" -> :right
            "1" -> :down
            "2" -> :left
            "3" -> :up
          end,
          String.to_integer(color_count_str, 16)
        }
      }
    end)
  end

  @doc """
  Executes the dig plan and returns the lagoon dimensions and capacity.
  """
  def dig_lagoon(dig_plan) do
    segments = dig_plan_to_segments(dig_plan)

    min_max_x =
      segments
      |> Enum.map(fn {_, x.._//_, _} -> x end)
      |> Enum.min_max()

    min_max_y =
      segments
      |> Enum.map(fn {_, _, y.._//_} -> y end)
      |> Enum.min_max()

    {y_min, y_max} = min_max_y

    lagoon_capacity =
      for y <- y_min..y_max do
        segments
        |> Enum.filter(fn {_, _, y_rgn} -> y in y_rgn end)
        |> Enum.sort_by(fn {_, x.._//_, _} -> x end)
        |> then(&count_lagoon_line_capacity/1)
      end
      |> Enum.sum()

    {{min_max_x, min_max_y}, lagoon_capacity}
  end

  defp dig_plan_to_segments(dig_plan) do
    {segments, _} =
      dig_plan
      |> Enum.with_index()
      |> Enum.reduce({[], {0, 0}}, fn {{dir, count}, i}, {segments, {x, y}} ->
        {dir_prev, _} = Enum.at(dig_plan, i - 1)
        next_index = if i == length(dig_plan) - 1, do: 0, else: i + 1
        {dir_next, _} = Enum.at(dig_plan, next_index)
        type = if dir_prev == dir_next, do: :border, else: :edge

        case dir do
          :right ->
            {
              [{type, x..(x + count), y..y} | segments],
              {x + count, y}
            }

          :left ->
            {
              [{type, (x - count)..x, y..y} | segments],
              {x - count, y}
            }

          :down ->
            {
              [{:border, x..x, (y + 1)..(y + count - 1)} | segments],
              {x, y + count}
            }

          :up ->
            {
              [{:border, x..x, (y - count + 1)..(y - 1)} | segments],
              {x, y - count}
            }
        end
      end)

    segments
  end

  defp count_lagoon_line_capacity(segments) do
    {count, _} =
      segments
      |> Enum.reduce(
        {0, nil},
        fn {type, x_start..x_end//_, _}, {count, x_enter} ->
          case {x_enter, type} do
            {nil, :border} -> {count, x_start}
            {_, :border} -> {count + x_end - x_enter + 1, nil}
            {nil, :edge} -> {count + x_end - x_start + 1, nil}
            {_, :edge} -> {count, x_enter}
          end
        end
      )

    count
  end
end
