defmodule Day21.GardenSteps do
  @moduledoc """
  You manage to catch the airship right as it's dropping someone else off on their all-expenses-paid trip to Desert Island! It even helpfully drops you off near the gardener and his massive farm.

  "You got the sand flowing again! Great work! Now we just need to wait until we have enough sand to filter the water for Snow Island and we'll have snow again in no time."

  While you wait, one of the Elves that works with the gardener heard how good you are at solving problems and would like your help. He needs to get his steps in for the day, and so he'd like to know which garden plots he can reach with exactly his remaining 64 steps.

  He gives you an up-to-date map (your puzzle input) of his starting position (S), garden plots (.), and rocks (#). For example:

  ```
  ...........
  .....###.#.
  .###.##..#.
  ..#.#...#..
  ....#.#....
  .##..S####.
  .##..#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
  ```
  The Elf starts at the starting position (S) which also counts as a garden plot. Then, he can take one step north, south, east, or west, but only onto tiles that are garden plots. This would allow him to reach any of the tiles marked O:

  ```
  ...........
  .....###.#.
  .###.##..#.
  ..#.#...#..
  ....#O#....
  .##.OS####.
  .##..#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
  ```
  Then, he takes a second step. Since at this point he could be at either tile marked O, his second step would allow him to reach any garden plot that is one step north, south, east, or west of any tile that he could have reached after the first step:

  ```
  ...........
  .....###.#.
  .###.##..#.
  ..#.#O..#..
  ....#.#....
  .##O.O####.
  .##.O#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
  ```
  After two steps, he could be at any of the tiles marked O above, including the starting position (either by going north-then-south or by going west-then-east).

  A single third step leads to even more possibilities:

  ```
  ...........
  .....###.#.
  .###.##..#.
  ..#.#.O.#..
  ...O#O#....
  .##.OS####.
  .##O.#...#.
  ....O..##..
  .##.#.####.
  .##..##.##.
  ...........
  ```
  He will continue like this until his steps for the day have been exhausted. After a total of 6 steps, he could reach any of the garden plots marked O:

  ```
  ...........
  .....###.#.
  .###.##.O#.
  .O#O#O.O#..
  O.O.#.#.O..
  .##O.O####.
  .##.O#O..#.
  .O.O.O.##..
  .##.#.####.
  .##O.##.##.
  ...........
  ```
  In this example, if the Elf's goal was to get exactly 6 more steps today, he could use them to reach any of 16 garden plots.

  However, the Elf actually needs to get 64 steps today, and the map he's handed you is much larger than the example map.

  Starting from the garden plot marked S on your map, how many garden plots could the Elf reach in exactly 64 steps?

  The actual number of steps he needs to get today is exactly 26501365.

  He also points out that the garden plots and rocks are set up so that the map repeats infinitely in every direction.

  So, if you were to look one additional map-width or map-height out from the edge of the example map above, you would find that it keeps repeating:

  ```
  .................................
  .....###.#......###.#......###.#.
  .###.##..#..###.##..#..###.##..#.
  ..#.#...#....#.#...#....#.#...#..
  ....#.#........#.#........#.#....
  .##...####..##...####..##...####.
  .##..#...#..##..#...#..##..#...#.
  .......##.........##.........##..
  .##.#.####..##.#.####..##.#.####.
  .##..##.##..##..##.##..##..##.##.
  .................................
  .................................
  .....###.#......###.#......###.#.
  .###.##..#..###.##..#..###.##..#.
  ..#.#...#....#.#...#....#.#...#..
  ....#.#........#.#........#.#....
  .##...####..##..S####..##...####.
  .##..#...#..##..#...#..##..#...#.
  .......##.........##.........##..
  .##.#.####..##.#.####..##.#.####.
  .##..##.##..##..##.##..##..##.##.
  .................................
  .................................
  .....###.#......###.#......###.#.
  .###.##..#..###.##..#..###.##..#.
  ..#.#...#....#.#...#....#.#...#..
  ....#.#........#.#........#.#....
  .##...####..##...####..##...####.
  .##..#...#..##..#...#..##..#...#.
  .......##.........##.........##..
  .##.#.####..##.#.####..##.#.####.
  .##..##.##..##..##.##..##..##.##.
  .................................
  ```
  This is just a tiny three-map-by-three-map slice of the inexplicably-infinite farm layout; garden plots and rocks repeat as far as you can see. The Elf still starts on the one middle tile marked S, though - every other repeated S is replaced with a normal garden plot (.).

  Here are the number of reachable garden plots in this new infinite version of the example map for different numbers of steps:

  - In exactly 6 steps, he can still reach 16 garden plots.
  - In exactly 10 steps, he can reach any of 50 garden plots.
  - In exactly 50 steps, he can reach 1594 garden plots.
  - In exactly 100 steps, he can reach 6536 garden plots.
  - In exactly 500 steps, he can reach 167004 garden plots.
  - In exactly 1000 steps, he can reach 668697 garden plots.
  - In exactly 5000 steps, he can reach 16733044 garden plots.

  However, the step count the Elf needs is much larger! Starting from the garden plot marked S on your infinite map, how many garden plots could the Elf reach in exactly 26501365 steps?
  """

  use Memoize

  def parse_garden_map(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    width = String.length(Enum.at(lines, 0))
    height = length(lines)

    rocks =
      lines
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {line, i}, acc ->
        MapSet.union(
          acc,
          line
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.filter(fn {c, _} -> c == "#" end)
          |> Enum.reduce(MapSet.new(), fn {_, j}, acc -> MapSet.put(acc, {i, j}) end)
        )
      end)

    starting_pos =
      lines
      |> Enum.with_index()
      |> Enum.find(fn {line, _} -> String.contains?(line, "S") end)
      |> then(fn {line, i} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.find(fn {c, _} -> c == "S" end)
        |> then(fn {_, j} -> {i, j} end)
      end)

    %{
      width: width,
      height: height,
      rocks: rocks,
      starting_pos: starting_pos
    }
  end

  @doc """
  Find the direct N/S/E/W neighbours for a position on the garden map.

  Excludes:
  - positions that are out of bounds of the map
  - positions that are rocks
  """
  def neighbours({x, y}, garden_map) do
    %{
      width: width,
      height: height,
      rocks: rocks
    } = garden_map

    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or x >= width or y >= height end)
    |> Enum.reject(fn pos -> MapSet.member?(rocks, pos) end)
  end

  @doc """
  Finds the positions reachable on the `garden map` by taking `step_counts` steps from the starting position.
  """
  def reachable_positions(steps_count, garden_map) do
    %{starting_pos: starting_pos} = garden_map

    1..steps_count
    |> Enum.reduce(MapSet.new([starting_pos]), fn _, positions ->
      positions
      |> Enum.flat_map(&neighbours(&1, garden_map))
      |> MapSet.new()
    end)
  end

  @doc """
  Find the direct N/S/E/W neighbours for a position on an infinite garden map.

  Wraps around the edges of the map.

  Excludes positions that are rocks.
  """
  def neighbours_infinite({x, y}, garden_map) do
    %{
      width: width,
      height: height,
      rocks: rocks
    } = garden_map

    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.reject(fn {x, y} ->
      MapSet.member?(rocks, {Integer.mod(x, height), Integer.mod(y, width)})
    end)
  end

  @doc """
  Finds the positions reachable on an infinite `garden map` by taking `step_counts` steps from the starting position.
  """
  defmemo reachable_positions_infinite(steps_count, garden_map) do
    %{starting_pos: starting_pos} = garden_map

    {_, visited_positions} =
      1..steps_count
      |> Enum.reduce(
        {MapSet.new([starting_pos]), %{starting_pos => 0}},
        fn i, {current_positions, visited_positions} ->
          new_positions =
            current_positions
            |> Enum.flat_map(fn pos ->
              neighbours_infinite(pos, garden_map)
              # reject positions that as already been visited
              |> Enum.reject(fn pos -> Map.has_key?(visited_positions, pos) end)
            end)
            |> MapSet.new()

          # update visited_positions map with the new reached positions
          # store the steps count for each position
          new_visited_positions =
            Enum.reduce(new_positions, visited_positions, fn pos, acc ->
              if Map.has_key?(acc, pos) do
                acc
              else
                Map.put(acc, pos, i)
              end
            end)

          {
            new_positions,
            new_visited_positions
          }
        end
      )

    # a position is reachable avec `steps_count` if it was reached 
    # after a number of steps that is the same modulo 2 as `steps_count`
    even_or_odd = Integer.mod(steps_count, 2)

    visited_positions
    |> Enum.filter(fn {_, i} -> Integer.mod(i, 2) == even_or_odd end)
  end

  @doc """
  Find the initial derivations series for the number of reachable positions in an infinite `garden map`.

  Taking the first four results of steps -> reachable tiles for step sizes at 
  - `(grid size // 2)`
  - `(grid size // 2) + (grid size)`
  - `(grid size // 2) + (grid size * 2)`
  - `(grid size // 2) + (grid size * 3)`
  """
  def initial_position_derivations(garden_map) do
    %{width: width} = garden_map

    suite =
      0..3
      |> Enum.map(fn i -> Integer.floor_div(width, 2) + i * width end)
      |> Enum.map(fn n_steps ->
        reachable_positions_infinite(n_steps, garden_map) |> Enum.count()
      end)

    Stream.cycle([1])
    |> Enum.reduce_while([suite], fn _, derivations ->
      [derivation | _] = derivations

      if derivation == [0] do
        {:halt, derivations}
      else
        new_derivation =
          Enum.zip_with([derivation, Enum.drop(derivation, 1)], fn [a, b] -> b - a end)

        {:cont, [new_derivation | derivations]}
      end
    end)
    |> Enum.map(&Enum.reverse/1)
  end

  @doc """
  Count the reachable positions after a BIG number of steps on an infinite `garden map`.

  And this is where it starts to get a bit...wonky. We can observe from
  the input that the number of steps the elf wants to take is a multiple
  of the grid size + (grid size // 2). The grid is 131 tiles square, so
  we can see that 26501365 = n * 131 + 65, with n = 202,300. We also
  note that, in the real input, there is a clear path from the start to
  each edge and each edge is clear all the way around. Additionally, the
  input forms a _diamond_ shape with a clear lane all the way around the
  manhattan distance of (grid size / 2) from the start. So, this means
  our zoomed out grid looks like:

  ```
  2....2
  ..11..
  ..11..
  2....2
  ```

  where the `1`'s represent the inner section of obstacles and the `2`'s
  represent the outer section of obstacles, which tiles to:

  ```
  2....22....22....22....22....2
  ..11....11....11....11....11..
  ..11....11....11....11....11..
  2....22....22....22....22....2
  2....22....22....22....22....2
  ..11....11....11....11....11..
  ..11....11....11....11....11..
  2....22....22....22....22....2
  2....22....22....22....22....2
  ..11....11....11....11....11..
  ..11....11....11....11....11..
  2....22....22....22....22....2
  2....22....22....22....22....2
  ..11....11....11....11....11..
  ..11....11....11....11....11..
  2....22....22....22....22....2
  2....22....22....22....22....2
  ..11....11....11....11....11..
  ..11....11....11....11....11..
  2....22....22....22....22....2
  ```

  So, without assuming that the `1` set of rocks and the `2` set of rocks
  are identical, we have alternating blocks of obstacles that form a
  repeating ring-like pattern around the center. We can then proceed on
  the assumption that these rings form the basis of a pattern in our
  output, like:

  - At (grid size / 2) steps, the elf's walking range encompasses the
    `1` set of obstacles in the center.
  - At (grid size / 2) + (grid size) steps, the elf's range now
    encompasses the entire first ring of obstacles, including 5 groups
    of `1`s and 4 groups of `2`s.
  - At (grid size / 2) + (grid size * 2), the elf's range now
    encompasses the first two rings of obstacles, including 13 groups
    of `1`'s and 12 groups of `2`'s.

  Because the number of obstacle groups included is scaling in some
  predictable fashion with an increase in number of steps by (grid size),
  we are able to manually find the first few results for the function
  steps -> reachable tiles and extrapolate the answer from there.
  """
  def count_reachable_positions_infinite(steps_count, garden_map) do
    %{width: width} = garden_map

    # Calculate the number of times we need to predict the next value as
    # the number of times we can increase the number of steps by the
    # grid size, up to the desired number of steps, starting at
    # (grid size // 2), aka: 26501365 = n * 131 + 65, with n = 202,300.
    iterations_count =
      Integer.floor_div(steps_count - Integer.floor_div(width, 2), width)

    # For my input, I get [3755, 33494, 92811, 181706] for these first four
    # counts of reachable tiles. The increase isn't linear, however, if we
    # repeatedly take the differences between the values in sequence...

    #     [3755, 33494, 92811, 181706]
    #       [29739, 59317, 88895]
    #           [29578, 29578]
    #                 [0]

    # It's Day 9! Or, rather, it's a polynomial sequence. There's definitely
    # math that can be done here to derive a formula for predicting the next
    # values based on this, but for my own sanity, I'm going to use the same
    # method from Day 9.
    derivations = initial_position_derivations(garden_map)

    # Now, we use the same procedure from Day 9 to predict the next value
    # in our sequence `numStepCycles` times, and return the last predicted
    # value.
    4..iterations_count
    |> Enum.reduce(derivations, fn _, derivations ->
      tl(derivations)
      |> Enum.reduce([[0]], fn derivation, new_derivations ->
        [prev | _] = new_derivations
        [p | _] = prev
        [n | _] = derivation
        new_derivation = [p + n | derivation]
        [new_derivation | new_derivations]
      end)
      |> Enum.reverse()
    end)
    |> List.last()
    |> List.first()
  end
end
