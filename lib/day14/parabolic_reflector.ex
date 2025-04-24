defmodule Day14.ParabolicReflector do
  @moduledoc """
  If you move the rocks, you can focus the dish. The platform even has a control panel on the side that lets you tilt it in one of four directions! The rounded rocks (O) will roll when the platform is tilted, while the cube-shaped rocks (#) will stay in place. You note the positions of all of the empty spaces (.) and rocks (your puzzle input). For example:
  ```
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  ```
  Start by tilting the lever so all of the rocks will slide north as far as they will go:

  ```
  OOOO.#.O..
  OO..#....#
  OO..O##..O
  O..#.OO...
  ........#.
  ..#....#.#
  ..O..#.O.O
  ..O.......
  #....###..
  #....#....
  ```
  You notice that the support beams along the north side of the platform are damaged; to ensure the platform doesn't collapse, you should calculate the total load on the north support beams.

  The amount of load caused by a single rounded rock (O) is equal to the number of rows from the rock to the south edge of the platform, including the row the rock is on. (Cube-shaped rocks (#) don't contribute to load.) So, the amount of load caused by each rock in each row is as follows:

  ```
  OOOO.#.O.. 10
  OO..#....#  9
  OO..O##..O  8
  O..#.OO...  7
  ........#.  6
  ..#....#.#  5
  ..O..#.O.O  4
  ..O.......  3
  #....###..  2
  #....#....  1
  ```
  The total load is the sum of the load caused by all of the rounded rocks. In this example, the total load is 136.

  The parabolic reflector dish deforms, but not in a way that focuses the beam. To do that, you'll need to move the rocks to the edges of the platform. Fortunately, a button on the side of the control panel labeled "spin cycle" attempts to do just that!

  Each cycle tilts the platform four times so that the rounded rocks roll north, then west, then south, then east. After each tilt, the rounded rocks roll as far as they can before the platform tilts in the next direction. After one cycle, the platform will have finished rolling the rounded rocks in those four directions in that order.

  Here's what happens in the example above after each of the first few cycles:

  After 1 cycle:
  ```
  .....#....
  ....#...O#
  ...OO##...
  .OO#......
  .....OOO#.
  .O#...O#.#
  ....O#....
  ......OOOO
  #...O###..
  #..OO#....
  ```

  After 2 cycles:
  ```
  .....#....
  ....#...O#
  .....##...
  ..O#......
  .....OOO#.
  .O#...O#.#
  ....O#...O
  .......OOO
  #..OO###..
  #.OOO#...O
  ```

  After 3 cycles:
  ```
  .....#....
  ....#...O#
  .....##...
  ..O#......
  .....OOO#.
  .O#...O#.#
  ....O#...O
  .......OOO
  #...O###.O
  #.OOO#...O
  ```
  This process should work if you leave it running long enough, but you're still worried about the north support beams. To make sure they'll survive for a while, you need to calculate the total load on the north support beams after 1000000000 cycles.

  In the above example, after 1000000000 cycles, the total load on the north support beams is 64.
  """

  use Memoize

  def parse_platform_map(input) do
    input
    |> String.split("\n", trim: true)
  end

  @doc """
  Cycles the platform n_cycles times.

  Each cycle consists of tilting the platform successively to the North, West, South and East.
  """
  def cycle(platform_map, n_cycles \\ 1) do
    cond do
      Integer.mod(n_cycles, 1000) == 0 ->
        1..trunc(n_cycles / 1000)
        |> Enum.reduce(rotate_left(platform_map), fn _, map ->
          cycle_internal_k(map)
        end)
        |> rotate_right()

      true ->
        1..n_cycles
        |> Enum.reduce(rotate_left(platform_map), fn _, map ->
          cycle_internal(map)
        end)
        |> rotate_right()
    end
  end

  defmemop cycle_internal_k(map) do
    1..1000
    |> Enum.reduce(map, fn _, map ->
      cycle_internal(map)
    end)
  end

  defmemop cycle_internal(map) do
    map
    |> tilt_west()
    |> rotate_right()
    |> tilt_west()
    |> rotate_right()
    |> tilt_west()
    |> rotate_right()
    |> tilt_west()
    |> rotate_right()
  end

  @doc """
  Tilts the platform to the West.
  """
  defmemo tilt_west(platform_map) do
    platform_map
    |> Enum.map(&tilt_row/1)
  end

  defmemop tilt_row(row) do
    row
    |> String.split("#")
    |> Enum.map(&tilt_chunk/1)
    |> Enum.join("#")
  end

  defmemop tilt_chunk(chunk) do
    chunk
    |> String.replace(".", "")
    |> String.pad_trailing(String.length(chunk), ".")
  end

  @doc """
  Tilts the platform to the East.
  """
  def tilt_east(platform_map) do
    reverse(platform_map)
    |> tilt_west()
    |> reverse()
  end

  @doc """
  Tilts the platform to the North.
  """
  def tilt_north(platform_map) do
    platform_map
    |> rotate_left()
    |> tilt_west()
    |> rotate_right()
  end

  @doc """
  Tilts the platform to the South.
  """
  def tilt_south(platform_map) do
    platform_map
    |> rotate_right()
    |> tilt_west()
    |> rotate_left()
  end

  @doc """
  Computes the total load of the North beams of the platform.
  """
  def total_load(platform_map) do
    platform_map
    |> Enum.with_index()
    |> Enum.sum_by(fn {line, i} ->
      (length(platform_map) - i) * String.length(String.replace(line, ["#", "."], ""))
    end)
  end

  defp reverse(platform_map) do
    Enum.map(platform_map, &String.reverse/1)
  end

  defp rotate_left(platform_map) do
    1..String.length(hd(platform_map))
    |> Enum.map(fn i ->
      platform_map
      |> Enum.map(&String.at(&1, -i))
      |> Enum.join("")
    end)
  end

  defp rotate_right(platform_map) do
    0..(String.length(hd(platform_map)) - 1)
    |> Enum.map(fn i ->
      platform_map
      |> Enum.map(&String.at(&1, i))
      |> Enum.join("")
      |> String.reverse()
    end)
  end
end
