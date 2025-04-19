defmodule Day05.AlmanacTest do
  use ExUnit.Case, async: true

  import Day05.Almanac

  @test_input """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  test "parse alamanac" do
    {seeds, seed_rngs, alamanac} =
      @test_input
      |> String.split("\n", trim: true)
      |> parse_almanac()

    assert seeds == [79, 14, 55, 13]

    assert seed_rngs == [79..92, 55..67]

    assert alamanac == %{
             "fertilizer-to-water" => %{
               (0..6) => 42,
               (7..10) => 50,
               (11..52) => -11,
               (53..60) => -4
             },
             "humidity-to-location" => %{
               (56..92) => 4,
               (93..96) => -37
             },
             "light-to-temperature" => %{
               (45..63) => 36,
               (64..76) => 4,
               (77..99) => -32
             },
             "seed-to-soil" => %{(50..97) => 2, (98..99) => -48},
             "soil-to-fertilizer" => %{
               (0..14) => 39,
               (15..51) => -15,
               (52..53) => -15
             },
             "temperature-to-humidity" => %{
               (0..68) => 1,
               (69..69) => -69
             },
             "water-to-light" => %{(18..24) => 70, (25..94) => -7}
           }
  end

  test "translate entries" do
    assert translate_entries(
             [79, 14, 55, 13],
             %{(50..97) => 2, (98..99) => -48}
           ) == [81, 14, 57, 13]

    assert translate_entries(
             [81, 14, 57, 13],
             %{
               (0..14) => 39,
               (15..51) => -15,
               (52..53) => -15
             }
           ) == [81, 53, 57, 52]
  end

  test "translate seeds to location" do
    assert translate_seeds_to_locations(
             [79, 14, 55, 13],
             %{
               "fertilizer-to-water" => %{
                 (0..6) => 42,
                 (7..10) => 50,
                 (11..52) => -11,
                 (53..60) => -4
               },
               "humidity-to-location" => %{
                 (56..92) => 4,
                 (93..96) => -37
               },
               "light-to-temperature" => %{
                 (45..63) => 36,
                 (64..76) => 4,
                 (77..99) => -32
               },
               "seed-to-soil" => %{
                 (50..97) => 2,
                 (98..99) => -48
               },
               "soil-to-fertilizer" => %{
                 (0..14) => 39,
                 (15..51) => -15,
                 (52..53) => -15
               },
               "temperature-to-humidity" => %{
                 (0..68) => 1,
                 (69..69) => -69
               },
               "water-to-light" => %{
                 (18..24) => 70,
                 (25..94) => -7
               }
             }
           ) == [82, 43, 86, 35]
  end

  test "translate range" do
    # input_rng included in translate_rng
    assert translate_rng(79..92, 50..97, 2) == {[81..94], []}
    # input_rng does not intersect in translate_rng
    assert translate_rng(79..92, 98..99, 2) == {[], [79..92]}
    # input_rng intersects translate_rng at the start
    assert translate_rng(79..92, 84..99, 2) == {[86..94], [79..83]}
    # input_rng intersects translate_rng at the end
    assert translate_rng(79..92, 70..84, 2) == {[81..86], [85..92]}
  end

  test "translate ranges through translations" do
    assert translate_rngs(
             [79..92, 55..67],
             Enum.to_list(%{
               (50..97) => 2,
               (98..99) => -48
             })
           ) == [81..94, 57..69]

    assert translate_rngs(
             [81..94, 57..69],
             %{
               (0..6) => 42,
               (7..10) => 50,
               (11..52) => -11,
               (53..60) => -4
             }
           ) == [53..56, 81..94, 61..69]
  end

  test "translate seed ranges to locations" do
    {_, seed_rngs, alamanac} =
      @test_input
      |> String.split("\n", trim: true)
      |> parse_almanac()

    assert translate_seed_rngs_to_locations(seed_rngs, alamanac)
           |> Enum.map(fn start.._//_ -> start end)
           |> Enum.min() == 46
  end
end
