defmodule Day08.DesertMapsTest do
  use ExUnit.Case, async: true
  import Day08.DesertMaps

  @test_input """
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  """

  @test_input_loop """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  @test_input_ghosts """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """

  test "parse desert maps" do
    assert parse_desert_maps(@test_input) == %{
             "directions" => "RL",
             "AAA" => {"BBB", "CCC"},
             "BBB" => {"DDD", "EEE"},
             "CCC" => {"ZZZ", "GGG"},
             "DDD" => {"DDD", "DDD"},
             "EEE" => {"EEE", "EEE"},
             "GGG" => {"GGG", "GGG"},
             "ZZZ" => {"ZZZ", "ZZZ"}
           }
  end

  test "follow directions" do
    assert @test_input
           |> parse_desert_maps()
           |> follow_directions() == [
             {"CCC", "ZZZ"},
             {"AAA", "CCC"}
           ]

    assert @test_input_loop
           |> parse_desert_maps()
           |> follow_directions() == [
             {"BBB", "ZZZ"},
             {"AAA", "BBB"},
             {"BBB", "AAA"},
             {"AAA", "BBB"},
             {"BBB", "AAA"},
             {"AAA", "BBB"}
           ]
  end

  test "follow directions as ghosts" do
    assert @test_input_ghosts
           |> parse_desert_maps()
           |> follow_directions_as_ghosts() == 6
  end
end
