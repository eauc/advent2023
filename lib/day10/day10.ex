defmodule Day10.Day10 do
  use ExUnit.Case

  def run() do
    maze =
      File.read!("lib/day10/input.txt")
      |> Day10.PipeMaze.parse_maze()

    min_branch_length =
      maze
      |> Day10.PipeMaze.follow_branches()
      |> Tuple.to_list()
      |> Enum.map(&Enum.count/1)
      |> Enum.min()

    IO.puts("Pipe loop min branch length: #{min_branch_length - 1}")
    assert min_branch_length - 1 == 7093

    tiles_inside_loop_count =
      maze
      |> Day10.PipeMaze.count_tiles_inside_loop()

    IO.puts("Tiles inside pipe loop: #{tiles_inside_loop_count}")
    assert tiles_inside_loop_count == 407
  end
end
