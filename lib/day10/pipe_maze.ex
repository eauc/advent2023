defmodule Day10.PipeMaze do
  @moduledoc """
  As you stop to admire some metal grass, you notice something metallic scurry away in your peripheral vision and jump into a big pipe! It didn't look like any animal you've ever seen; if you want a better look, you'll need to get ahead of it.

  Scanning the area, you discover that the entire field you're standing on is densely packed with pipes; it was hard to tell at first because they're the same metallic silver color as the "ground". You make a quick sketch of all of the surface pipes you can see (your puzzle input).

  The pipes are arranged in a two-dimensional grid of tiles:

  | is a vertical pipe connecting north and south.
  - is a horizontal pipe connecting east and west.
  L is a 90-degree bend connecting north and east.
  J is a 90-degree bend connecting north and west.
  7 is a 90-degree bend connecting south and west.
  F is a 90-degree bend connecting south and east.
  . is ground; there is no pipe in this tile.
  S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
  Based on the acoustics of the animal's scurrying, you're confident the pipe that contains the animal is one large, continuous loop.

  For example, here is a square loop of pipe:

  ```
  .....
  .F-7.
  .|.|.
  .L-J.
  .....
  ```
  If the animal had entered this loop in the northwest corner, the sketch would instead look like this:

  ```
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  ```
  In the above diagram, the S tile is still a 90-degree F bend: you can tell because of how the adjacent pipes connect to it.

  Unfortunately, there are also many pipes that aren't connected to the loop! This sketch shows the same loop as above:

  ```
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
  ```
  In the above diagram, you can still figure out which pipes form the main loop: they're the ones connected to S, pipes those pipes connect to, pipes those pipes connect to, and so on. Every pipe in the main loop connects to its two neighbors (including S, which will have exactly two pipes connecting to it, and which is assumed to connect back to those two pipes).

  Here is a sketch that contains a slightly more complex main loop:

  ```
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  ```
  Here's the same example sketch with the extra, non-main-loop pipe tiles also shown:

  ```
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
  ```
  If you want to get out ahead of the animal, you should find the tile in the loop that is farthest from the starting position. Because the animal is in the pipe, it doesn't make sense to measure this by direct distance. Instead, you need to find the tile that would take the longest number of steps along the loop to reach from the starting point - regardless of which way around the loop the animal went.

  In the first example with the square loop:

  ```
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  ```
  You can count the distance each tile in the loop is from the starting point like this:

  ```
  .....
  .012.
  .1.3.
  .234.
  .....
  ```
  In this example, the farthest point from the start is 4 steps away.

  Here's the more complex loop again:

  ```
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  ```
  Here are the distances for each tile on that loop:

  ```
  ..45.
  .236.
  01.78
  14567
  23...
  ```

  You quickly reach the farthest point of the loop, but the animal never emerges. Maybe its nest is within the area enclosed by the loop?

  To determine whether it's even worth taking the time to search for such a nest, you should calculate how many tiles are contained within the loop. For example:

  ```
  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........
  ```
  The above loop encloses merely four tiles - the two pairs of . in the southwest and southeast (marked I below). The middle . tiles (marked O below) are not in the loop. Here is the same loop again with those regions marked:

  ```
  ...........
  .S-------7.
  .|F-----7|.
  .||OOOOO||.
  .||OOOOO||.
  .|L-7OF-J|.
  .|II|O|II|.
  .L--JOL--J.
  .....O.....
  ```
  In fact, there doesn't even need to be a full tile path to the outside for tiles to count as outside the loop - squeezing between pipes is also allowed! Here, I is still within the loop and O is still outside the loop:

  ```
  ..........
  .S------7.
  .|F----7|.
  .||OOOO||.
  .||OOOO||.
  .|L-7F-J|.
  .|II||II|.
  .L--JL--J.
  ..........
  ```
  In both of the above examples, 4 tiles are enclosed by the loop.

  Here's a larger example:

  ```
  .F----7F7F7F7F-7....
  .|F--7||||||||FJ....
  .||.FJ||||||||L7....
  FJL7L7LJLJ||LJ.L-7..
  L--J.L7...LJS7F-7L7.
  ....F-J..F7FJ|L7L7L7
  ....L7.F7||L7|.L7L7|
  .....|FJLJ|FJ|F7|.LJ
  ....FJL-7.||.||||...
  ....L---J.LJ.LJLJ...
  ```
  The above sketch has many random bits of ground, some of which are in the loop (I) and some of which are outside it (O):

  ```
  OF----7F7F7F7F-7OOOO
  O|F--7||||||||FJOOOO
  O||OFJ||||||||L7OOOO
  FJL7L7LJLJ||LJIL-7OO
  L--JOL7IIILJS7F-7L7O
  OOOOF-JIIF7FJ|L7L7L7
  OOOOL7IF7||L7|IL7L7|
  OOOOO|FJLJ|FJ|F7|OLJ
  OOOOFJL-7O||O||||OOO
  OOOOL---JOLJOLJLJOOO
  ```
  In this larger example, 8 tiles are enclosed by the loop.

  Any tile that isn't part of the main loop can count as being enclosed by the loop. Here's another example with many bits of junk pipe lying around that aren't connected to the main loop at all:

  ```
  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJ7F7FJ-
  L---JF-JLJ.||-FJLJJ7
  |F|F-JF---7F7-L7L|7|
  |FFJF7L7F-JF7|JL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L
  ```
  Here are just the tiles that are enclosed by the loop marked with I:

  ```
  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJIF7FJ-
  L---JF-JLJIIIIFJLJJ7
  |F|F-JF---7IIIL7L|7|
  |FFJF7L7F-JF7IIL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L
  ```
  In this last example, 10 tiles are enclosed by the loop.
  """

  require Integer

  def parse_maze(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  @doc """
  Finds the starting position in the maze, noted ?S.

  Returns a position tuple `{row, col}`.
  """
  def find_starting_position(maze) do
    {{?S, col}, row} =
      maze
      |> Enum.map(fn line ->
        line
        |> Enum.with_index()
        |> Enum.find(fn {char, _} -> char == ?S end)
      end)
      |> Enum.with_index()
      |> Enum.find(fn {x, _} -> x != nil end)

    {row, col}
  end

  @doc """
  Finds the start of each branch of the loop in the maze.

  - Find the connected neighbours of the starting position.
  - Determines the pipe at starting position from its connected neighbours.
  - Updates the maze by replacing the ?S at starting position with the starting pipe.

  Returns a position tuple `{left branch, right branch, updated maze}`.
  """
  def find_starting_branches(maze) do
    start = find_starting_position(maze)

    {srow, scol} = start

    [lpos, rpos] =
      [{srow - 1, scol}, {srow + 1, scol}, {srow, scol - 1}, {srow, scol + 1}]
      |> Enum.filter(fn {row, col} ->
        neighbour_pipe = pipe_at(maze, {row, col})

        find_next_position(start, {row, col}, neighbour_pipe)
      end)

    start_count_as =
      case {{elem(lpos, 0) - srow, elem(lpos, 1) - scol},
            {elem(rpos, 0) - srow, elem(rpos, 1) - scol}} do
        {{-1, 0}, {1, 0}} -> ?|
        {{-1, 0}, {0, -1}} -> ?J
        {{-1, 0}, {0, 1}} -> ?L
        {{1, 0}, {0, -1}} -> ?7
        {{1, 0}, {0, 1}} -> ?F
        {{0, -1}, {0, 1}} -> ?-
      end

    {
      [lpos, start],
      [rpos, start],
      update_at(maze, start, start_count_as)
    }
  end

  @doc """
  Follows each branches of the loop found in maze.

  Stops when the branches meet.
  Returns a pair of `{left branch, right branch}`.
  """
  def follow_branches(maze) do
    {lbranch, rbranch, _} = find_starting_branches(maze)
    follow_branches(maze, {lbranch, rbranch})
  end

  @doc """
  Follows each branches `{lbranch, rbranch}`.

  Stops when the branches meet.
  Returns a pair of completed `{left branch, right branch}`.
  """
  def follow_branches(maze, branches)

  def follow_branches(maze, {lbranch, rbranch}) do
    [lpos | [lprev | _]] = lbranch
    lpipe = pipe_at(maze, lpos)
    lnext = find_next_position(lprev, lpos, lpipe)

    [rpos | [rprev | _]] = rbranch
    rpipe = pipe_at(maze, rpos)
    rnext = find_next_position(rprev, rpos, rpipe)

    acc = {[lnext | lbranch], [rnext | rbranch]}

    case lnext == rnext or lnext == rpos or rnext == lpos do
      true -> acc
      false -> follow_branches(maze, acc)
    end
  end

  @doc """
  Counts the number of tiles inside the loop in the maze.
  """
  def count_tiles_inside_loop(maze) do
    {lbranch, rbranch} = follow_branches(maze)
    loop_positions = MapSet.new(lbranch ++ rbranch)

    {_, _, maze} = find_starting_branches(maze)

    maze
    |> Enum.with_index()
    |> Enum.map(fn {line, row} ->
      line
      |> Enum.with_index()
      |> Enum.filter(fn {_, col} ->
        inside?(maze, loop_positions, {row, col})
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  @doc """
  Checks if the given position is inside the loop.

  Uses an even/odd alogrithm, counting the number of crossings over the loop when iterating from position to the right of the maze on the same line.
  - if the number of crossing is even, the position is outside the loop
  - if the number of crossing is odd, the position is inside the loop
  """
  def inside?(pipe_maze, loop_positions, pos) do
    case MapSet.member?(loop_positions, pos) do
      true ->
        false

      false ->
        {srow, scol} = pos

        {crossings_count, _} =
          for col <- scol..(Enum.count(Enum.at(pipe_maze, srow)) - 1), reduce: {0, nil} do
            {crossings_count, crossing_from} ->
              if MapSet.member?(loop_positions, {srow, col}) do
                pipe = pipe_at(pipe_maze, {srow, col})

                count_crossings(crossings_count, pipe, crossing_from)
              else
                {crossings_count, crossing_from}
              end
          end

        Integer.is_odd(crossings_count)
    end
  end

  # vertical pipes always count as crossing the loop
  defp count_crossings(crossings_count, ?|, nil), do: {crossings_count + 1, nil}

  # horizontal pipes never count as crossing the loop, aka "it is allowed to squeeze along the pipes"
  defp count_crossings(crossings_count, ?-, crossing_from), do: {crossings_count, crossing_from}
  # lower left bends only count as crossing if we later encounter a upper right bend
  defp count_crossings(crossings_count, ?L, nil), do: {crossings_count, ?L}
  # upper right bends only count as crossing if we previously encountered a lower left bend
  defp count_crossings(crossings_count, ?7, ?L), do: {crossings_count + 1, nil}
  # upper right bends do not count as crossing if we previously encountered a upper left bend
  defp count_crossings(crossings_count, ?7, ?F), do: {crossings_count, nil}
  # upper left bends only count as crossing if we later encounter a lower right bend
  defp count_crossings(crossings_count, ?F, nil), do: {crossings_count, ?F}
  # lower right bends only count as crossing if we previously encountered a upper left bend
  defp count_crossings(crossings_count, ?J, ?F), do: {crossings_count + 1, nil}
  # lower right bends do not count as crossing if we previously encountered a lower left bend
  defp count_crossings(crossings_count, ?J, ?L), do: {crossings_count, nil}

  @doc """
  Updates the maze by replacing the pipe at the given position.
  """
  def update_at(maze, pos, pipe) do
    {row, col} = pos

    List.replace_at(
      maze,
      row,
      List.replace_at(Enum.at(maze, row), col, pipe)
    )
  end

  defp pipe_at(maze, {row, col}) do
    if row < 0 or col < 0 do
      ?.
    else
      maze
      |> Enum.at(row)
      |> Enum.at(col)
    end
  end

  defp find_next_position({r, a}, {r, b}, ?-) when a < b, do: {r, b + 1}
  defp find_next_position({r, a}, {r, b}, ?J) when a < b, do: {r - 1, b}
  defp find_next_position({r, a}, {r, b}, ?7) when a < b, do: {r + 1, b}
  defp find_next_position({r, a}, {r, b}, ?-) when a > b, do: {r, b - 1}
  defp find_next_position({r, a}, {r, b}, ?L) when a > b, do: {r - 1, b}
  defp find_next_position({r, a}, {r, b}, ?F) when a > b, do: {r + 1, b}
  defp find_next_position({a, c}, {b, c}, ?|) when a < b, do: {b + 1, c}
  defp find_next_position({a, c}, {b, c}, ?J) when a < b, do: {b, c - 1}
  defp find_next_position({a, c}, {b, c}, ?L) when a < b, do: {b, c + 1}
  defp find_next_position({a, c}, {b, c}, ?|) when a > b, do: {b - 1, c}
  defp find_next_position({a, c}, {b, c}, ?7) when a > b, do: {b, c - 1}
  defp find_next_position({a, c}, {b, c}, ?F) when a > b, do: {b, c + 1}
  defp find_next_position(_, _, _), do: nil
end
