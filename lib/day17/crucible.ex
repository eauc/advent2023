defmodule Day17.Crucible do
  @moduledoc """
  Fortunately, the Elves here have a map (your puzzle input) that uses traffic patterns, ambient temperature, and hundreds of other parameters to calculate exactly how much heat loss can be expected for a crucible entering any particular city block.

  For example:

  ```
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
  ```
  Each city block is marked by a single digit that represents the amount of heat loss if the crucible enters that block. The starting point, the lava pool, is the top-left city block; the destination, the machine parts factory, is the bottom-right city block. (Because you already start in the top-left block, you don't incur that block's heat loss unless you leave that block and then return to it.)

  Because it is difficult to keep the top-heavy crucible going in a straight line for very long, it can move at most three blocks in a single direction before it must turn 90 degrees left or right. The crucible also can't reverse direction; after entering each city block, it may only turn left, continue straight, or turn right.

  One way to minimize heat loss is this path:

  ```
  2>>34^>>>1323
  32v>>>35v5623
  32552456v>>54
  3446585845v52
  4546657867v>6
  14385987984v4
  44578769877v6
  36378779796v>
  465496798688v
  456467998645v
  12246868655<v
  25465488877v5
  43226746555v>
  ```
  This path never moves more than three consecutive blocks in the same direction and incurs a heat loss of only 102.

  Ultra crucibles are even more difficult to steer than normal crucibles. Not only do they have trouble going in a straight line, but they also have trouble turning!

  Once an ultra crucible starts moving in a direction, it needs to move a minimum of four blocks in that direction before it can turn (or even before it can stop at the end). However, it will eventually start to get wobbly: an ultra crucible can move a maximum of ten consecutive blocks without turning.

  In the above example, an ultra crucible could follow this path to minimize heat loss:

  ```
  2>>>>>>>>1323
  32154535v5623
  32552456v4254
  34465858v5452
  45466578v>>>>
  143859879845v
  445787698776v
  363787797965v
  465496798688v
  456467998645v
  122468686556v
  254654888773v
  432267465553v
  ```
  In the above example, an ultra crucible would incur the minimum possible heat loss of 94.
  """

  def parse_city_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Calculates the minimum heat loss path cost with normal crucibles.
  """
  def minimum_heat_loss_path_cost(city_map) do
    map_dimensions = {length(hd(city_map)), length(city_map)}

    minimum_heat_loss_path_cost(
      city_map,
      map_dimensions,
      [
        {0, [{:right, 0, 0}]},
        {0, [{:down, 0, 0}]}
      ]
      |> Enum.into(Heap.min()),
      MapSet.new(),
      &next_positions_simple/2
    )
  end

  @doc """
  Calculates the minimum heat loss path cost with ultra crucibles.
  """
  def minimum_heat_loss_path_cost_ultra(city_map) do
    map_dimensions = {length(hd(city_map)), length(city_map)}

    minimum_heat_loss_path_cost(
      city_map,
      map_dimensions,
      [
        {0, [{:right, 0, 0}]},
        {0, [{:down, 0, 0}]}
      ]
      |> Enum.into(Heap.min()),
      MapSet.new(),
      &next_positions_ultra/2
    )
  end

  defp minimum_heat_loss_path_cost(city_map, map_dimensions, from, seen, next_positions) do
    {{cost, last_positions}, rest} = Heap.split(from)
    {_, x, y} = hd(last_positions)

    cond do
      {x + 1, y + 1} == map_dimensions ->
        cost

      MapSet.member?(seen, last_positions) ->
        minimum_heat_loss_path_cost(city_map, map_dimensions, rest, seen, next_positions)

      true ->
        # IO.inspect({cost, last_positions})

        candidates =
          next_positions.(last_positions, map_dimensions)
          |> Enum.map(fn new_last_pos ->
            {_, x, y} = hd(new_last_pos)

            {
              cost + (city_map |> Enum.at(y) |> Enum.at(x)),
              new_last_pos
            }
          end)

        minimum_heat_loss_path_cost(
          city_map,
          map_dimensions,
          Enum.into(candidates, rest),
          MapSet.put(seen, last_positions),
          next_positions
        )
    end
  end

  @doc """
  Calculates the next possible positions for a normal crucible.

  - normal crucibles can't go more than 3 blocks in the same direction.

  Returns a list of (the last 3 positions for each new position).
  """
  def next_positions_simple(last_3, {map_width, map_height}) do
    {last_dir, last_x, last_y} = hd(last_3)

    max_3_in_same_direction? =
      Enum.all?(last_3, fn {d, _, _} -> d == last_dir end) and length(last_3) >= 3

    [
      {:right, last_x + 1, last_y},
      {:left, last_x - 1, last_y},
      {:down, last_x, last_y + 1},
      {:up, last_x, last_y - 1}
    ]
    |> Enum.reject(fn {dir, x, y} ->
      x < 0 or x >= map_width or y < 0 or y >= map_height or
        opposite_directions(dir, last_dir) or
        (max_3_in_same_direction? and dir == last_dir)
    end)
    |> Enum.map(fn new_pos ->
      Enum.take([new_pos | last_3], 3)
    end)
  end

  @doc """
  Calculates the next possible positions for an ultra crucible.

  - ultra crucibles can't change direction before running at least 4 blocks in the same direction.
  - ultra crucibles can't go more than 10 blocks in the same direction.

  Returns a list of (the last 10 positions for each new position).
  """
  def next_positions_ultra(last_10, {map_width, map_height}) do
    {last_dir, last_x, last_y} = hd(last_10)

    last_4 = Enum.take(last_10, 4)

    min_4_in_same_direction? =
      Enum.all?(last_4, fn {d, _, _} -> d == last_dir end) and length(last_4) >= 4

    max_10_in_same_direction? =
      Enum.all?(last_10, fn {d, _, _} -> d == last_dir end) and length(last_10) >= 10

    [
      {:right, last_x + 1, last_y},
      {:left, last_x - 1, last_y},
      {:down, last_x, last_y + 1},
      {:up, last_x, last_y - 1}
    ]
    |> Enum.reject(fn {dir, x, y} ->
      x < 0 or x >= map_width or y < 0 or y >= map_height or
        opposite_directions(dir, last_dir) or
        (!min_4_in_same_direction? and dir != last_dir) or
        (max_10_in_same_direction? and dir == last_dir)
    end)
    |> Enum.map(fn new_pos ->
      Enum.take([new_pos | last_10], 10)
    end)
  end

  defp opposite_directions(:right, :left), do: true
  defp opposite_directions(:left, :right), do: true
  defp opposite_directions(:up, :down), do: true
  defp opposite_directions(:down, :up), do: true
  defp opposite_directions(_, _), do: false
end
