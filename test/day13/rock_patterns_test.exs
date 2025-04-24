defmodule Day13.RockPatternsTest do
  use ExUnit.Case, async: true

  import Day13.RockPatterns

  @test_input """
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.

  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  """

  test "parse rock patterns" do
    assert parse_rock_patterns(@test_input) == [
             [
               "#.##..##.",
               "..#.##.#.",
               "##......#",
               "##......#",
               "..#.##.#.",
               "..##..##.",
               "#.#.##.#."
             ],
             [
               "#...##..#",
               "#....#..#",
               "..##..###",
               "#####.##.",
               "#####.##.",
               "..##..###",
               "#....#..#"
             ]
           ]
  end

  test "find horizontal mirror" do
    assert find_horizontal_mirror([
             "#.##..##.",
             "..#.##.#.",
             "##......#",
             "##......#",
             "..#.##.#.",
             "..##..##.",
             "#.#.##.#."
           ]) == nil

    assert find_horizontal_mirror([
             "#...##..#",
             "#....#..#",
             "..##..###",
             "#####.##.",
             "#####.##.",
             "..##..###",
             "#....#..#"
           ]) == 4
  end

  test "find vertical mirror" do
    assert find_vertical_mirror([
             "#.##..##.",
             "..#.##.#.",
             "##......#",
             "##......#",
             "..#.##.#.",
             "..##..##.",
             "#.#.##.#."
           ]) == 5

    assert find_vertical_mirror([
             "#...##..#",
             "#....#..#",
             "..##..###",
             "#####.##.",
             "#####.##.",
             "..##..###",
             "#....#..#"
           ]) == nil
  end

  test "summarize rock patterns" do
    assert @test_input
           |> parse_rock_patterns()
           |> summarize() == 405
  end

  test "find horizontal mirror with smudge correction" do
    assert find_horizontal_mirror_with_smudge_correction([
             "#.##..##.",
             "..#.##.#.",
             "##......#",
             "##......#",
             "..#.##.#.",
             "..##..##.",
             "#.#.##.#."
           ]) == 3

    assert find_horizontal_mirror_with_smudge_correction([
             "#...##..#",
             "#....#..#",
             "..##..###",
             "#####.##.",
             "#####.##.",
             "..##..###",
             "#....#..#"
           ]) == 1
  end

  test "find vertical mirror with smudge correction" do
    assert find_vertical_mirror_with_smudge_correction([
             "#.##..##.",
             "..#.##.#.",
             "##......#",
             "##......#",
             "..#.##.#.",
             "..##..##.",
             "#.#.##.#."
           ]) == nil

    assert find_vertical_mirror_with_smudge_correction([
             "#...##..#",
             "#....#..#",
             "..##..###",
             "#####.##.",
             "#####.##.",
             "..##..###",
             "#....#..#"
           ]) == nil
  end

  test "summarize rock patterns with smudge correction" do
    assert @test_input
           |> parse_rock_patterns()
           |> summarize_with_smudge_correction() == 400
  end
end
