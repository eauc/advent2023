defmodule Day08.DesertMaps do
  @moduledoc """
  One of the camel's pouches is labeled "maps" - sure enough, it's full of documents (your puzzle input) about how to navigate the desert. At least, you're pretty sure that's what they are; one of the documents contains a list of left/right instructions, and the rest of the documents seem to describe some kind of network of labeled nodes.

  It seems like you're meant to use the left/right instructions to navigate the network. Perhaps if you have the camel follow the same instructions, you can escape the haunted wasteland!

  After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel like AAA is where you are now, and you have to follow the left/right instructions until you reach ZZZ.

  This format defines each node of the network individually. For example:
  ```
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  ```
  Starting with AAA, you need to look up the next element based on the next left/right instruction in your input. In this example, start with AAA and go right (R) by choosing the right element of AAA, CCC. Then, L means to choose the left element of CCC, ZZZ. By following the left/right instructions, you reach ZZZ in 2 steps.

  Of course, you might not find ZZZ right away. If you run out of left/right instructions, repeat the whole sequence of instructions as necessary: RL really means RLRLRLRLRLRLRLRL... and so on. For example, here is a situation that takes 6 steps to reach ZZZ:
  ```
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  ```
  """

  def parse_desert_maps(input) do
    [directions, node_lines] =
      input
      |> String.split("\n\n", trim: true)

    node_lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [key, leaves] = String.split(line, " = ", trim: true)

      [left, right] =
        Regex.run(~r/^\(([^,]+), ([^)]+)\)$/, leaves, capture: :all_but_first, trim: true)

      {key, {left, right}}
    end)
    |> Enum.into(%{"directions" => directions})
  end

  @doc """
  Follows the direction in the desert map until we reach the destination node `ZZZ`.

  Return the list of steps taken.
  """
  def follow_directions(desert_map) do
    %{"directions" => directions} = desert_map

    {steps, _} =
      directions
      |> String.to_charlist()
      |> Stream.cycle()
      |> Enum.reduce_while({[], "AAA"}, fn direction, {steps, current_node} ->
        new_node =
          case direction do
            ?L -> desert_map[current_node] |> elem(0)
            ?R -> desert_map[current_node] |> elem(1)
          end

        acc = {[{current_node, new_node} | steps], new_node}

        case new_node do
          "ZZZ" -> {:halt, acc}
          _ -> {:cont, acc}
        end
      end)

    steps
  end

  @doc """
  Follows the direction in the desert map as ghosts until they all reach a destination node ending with `__Z` at the same time.

  Returns the number of steps taken to reach the destinations.

  Explanation:
  - all ghosts first reach a destination after N(ghosts) steps
  - then each ghost with reach the same destination again, after a number of steps repeating in a cycle, ie ghost 1 will reach its destination after N(1), 2xN(2), 3xN(3), etc
  - so we first find the first number of steps required to reach a destination for each ghost (`z_indices`)
  - then we find the least common multiple of these numbers
  """
  def follow_directions_as_ghosts(desert_map) do
    z_indices = first_z_indices(desert_map)

    lcm(z_indices)
  end

  defp first_z_indices(desert_map) do
    %{"directions" => directions} = desert_map

    initial_positions =
      desert_map
      |> Map.keys()
      |> Enum.filter(fn key -> String.ends_with?(key, "A") end)

    {z_indices, _, _} =
      directions
      |> String.to_charlist()
      |> Stream.cycle()
      |> Enum.reduce_while(
        {
          # initial z_indices = %{0 => 0, 1 => 0, 2 => 0, ...}
          Enum.with_index(initial_positions) |> Enum.map(fn {_, i} -> {i, 0} end) |> Map.new(),
          # list of steps taken (a counter would suffice but useful for debug)
          [initial_positions],
          # current positions of each ghost
          initial_positions
        },
        fn direction, {z_indices, steps, current_positions} ->
          # follow map directions for each ghots
          new_positions =
            current_positions
            |> Enum.map(fn position ->
              case direction do
                ?L -> desert_map[position] |> elem(0)
                ?R -> desert_map[position] |> elem(1)
              end
            end)

          # insert new z_indices if new position ends with "Z" 
          # and its the first time this ghost reaches a destination
          new_z_indices =
            new_positions
            |> Enum.with_index()
            |> Enum.reduce(
              z_indices,
              fn {new_pos, i}, z_indices ->
                if String.ends_with?(new_pos, "Z") and z_indices[i] == 0 do
                  Map.put(z_indices, i, Enum.count(steps))
                else
                  z_indices
                end
              end
            )

          acc = {
            new_z_indices,
            [new_positions | steps],
            new_positions
          }

          # stop when we have found the first z_index for all ghosts
          case Map.values(new_z_indices) |> Enum.all?(fn value -> value > 0 end) do
            true -> {:halt, acc}
            false -> {:cont, acc}
          end
        end
      )

    z_indices
  end

  defp lcm(z_indices) do
    z_indices
    |> Map.values()
    |> Enum.reduce(fn a, b -> trunc(a * b / Integer.gcd(a, b)) end)
  end
end
