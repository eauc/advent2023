defmodule Day10.PipeMazeTest do
  use ExUnit.Case, async: true

  import Day10.PipeMaze

  @test_input_small """
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
  """

  @test_input_large """
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
  """

  test "parse maze" do
    assert parse_maze(@test_input_small) == [
             ~c"-L|F7",
             ~c"7S-7|",
             ~c"L|7||",
             ~c"-L-J|",
             ~c"L|-JF"
           ]

    assert parse_maze(@test_input_large) == [
             ~c"7-F7-",
             ~c".FJ|7",
             ~c"SJLL7",
             ~c"|F--J",
             ~c"LJ.LJ"
           ]
  end

  test "find starting position" do
    assert parse_maze(@test_input_small)
           |> find_starting_position() == {1, 1}

    assert parse_maze(@test_input_large)
           |> find_starting_position() == {2, 0}
  end

  test "find starting branches" do
    assert parse_maze(@test_input_small)
           |> find_starting_branches() == {
             [{2, 1}, {1, 1}],
             [{1, 2}, {1, 1}],
             update_at(parse_maze(@test_input_small), {1, 1}, ?F)
           }

    assert parse_maze(@test_input_large)
           |> find_starting_branches() == {
             [{3, 0}, {2, 0}],
             [{2, 1}, {2, 0}],
             update_at(parse_maze(@test_input_large), {2, 0}, ?F)
           }
  end

  test "follow branches" do
    assert parse_maze(@test_input_small)
           |> follow_branches() ==
             {
               [{3, 3}, {3, 2}, {3, 1}, {2, 1}, {1, 1}],
               [{3, 3}, {2, 3}, {1, 3}, {1, 2}, {1, 1}]
             }

    assert parse_maze(@test_input_large)
           |> follow_branches() ==
             {
               [{2, 4}, {3, 4}, {3, 3}, {3, 2}, {3, 1}, {4, 1}, {4, 0}, {3, 0}, {2, 0}],
               [{2, 4}, {2, 3}, {1, 3}, {0, 3}, {0, 2}, {1, 2}, {1, 1}, {2, 1}, {2, 0}]
             }
  end

  test "branches length" do
    assert @test_input_small
           |> parse_maze()
           |> follow_branches()
           |> Tuple.to_list()
           |> Enum.map(&Enum.count/1)
           |> Enum.min() == 5

    assert @test_input_large
           |> parse_maze()
           |> follow_branches()
           |> Tuple.to_list()
           |> Enum.map(&Enum.count/1)
           |> Enum.min() == 9
  end

  @test_input_inside_outside_small """
  ..........
  .S------7.
  .|F----7|.
  .||....||.
  .||....||.
  .|L-7F-J|.
  .|..||..|.
  .L--JL--J.
  ..........
  """

  @test_input_inside_outside_large_1 """
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
  """

  @test_input_inside_outside_large_2 """
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
  """

  test "inside or outside" do
    pipe_maze = parse_maze(@test_input_inside_outside_small)
    {lbranch, rbranch} = follow_branches(pipe_maze)
    loop_positions = MapSet.new(lbranch ++ rbranch)

    {_, _, pipe_maze} = find_starting_branches(pipe_maze)

    assert inside?(pipe_maze, loop_positions, {0, 0}) == false
    assert inside?(pipe_maze, loop_positions, {2, 0}) == false
    assert inside?(pipe_maze, loop_positions, {6, 2}) == true
    assert inside?(pipe_maze, loop_positions, {3, 2}) == false
  end

  test "count tiles inside loop" do
    assert parse_maze(@test_input_inside_outside_small)
           |> count_tiles_inside_loop() == 4
    assert parse_maze(@test_input_inside_outside_large_1)
           |> count_tiles_inside_loop() == 8
    assert parse_maze(@test_input_inside_outside_large_2)
           |> count_tiles_inside_loop() == 10
  end
end
