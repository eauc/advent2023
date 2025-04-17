defmodule Day03.GearRatiosTest do
  use ExUnit.Case, async: true

  import Day03.GearRatios

  test "parse part numbers candidates/line" do
    assert parse_part_numbers_candidates("...*......", 1) == []

    assert parse_part_numbers_candidates("467..114..", 1) == [
             %{number: 467, line: 1, column_rng: 0..2},
             %{number: 114, line: 1, column_rng: 5..7}
           ]
  end

  test "parse part numbers candidates/engine map" do
    part_numbers =
      Stream.uniq([
        "467..114..\n",
        "...*......\n",
        "..35..633.\n",
        "......#...\n",
        "617*......\n",
        ".....+.58.\n",
        "..592.....\n",
        "......755.\n",
        "...$.*....\n",
        ".664.598..\n"
      ])
      |> parse_part_numbers_candidates()

    assert part_numbers == [
             %{line: 0, number: 467, column_rng: 0..2},
             %{line: 0, number: 114, column_rng: 5..7},
             %{line: 2, number: 35, column_rng: 2..3},
             %{line: 2, number: 633, column_rng: 6..8},
             %{line: 4, number: 617, column_rng: 0..2},
             %{line: 5, number: 58, column_rng: 7..8},
             %{line: 6, number: 592, column_rng: 2..4},
             %{line: 7, number: 755, column_rng: 6..8},
             %{line: 9, number: 664, column_rng: 1..3},
             %{line: 9, number: 598, column_rng: 5..7}
           ]
  end

  test "parse part numbers" do
    part_numbers =
      Stream.uniq([
        "467..114..\n",
        "...*......\n",
        "..35..633.\n",
        "......#...\n",
        "617*......\n",
        ".....+.58.\n",
        "..592.....\n",
        "......755.\n",
        "...$.*....\n",
        ".664.598..\n"
      ])
      |> parse_part_numbers()

    assert part_numbers == [
             %{line: 0, number: 467, column_rng: 0..2},
             %{line: 2, number: 35, column_rng: 2..3},
             %{line: 2, number: 633, column_rng: 6..8},
             %{line: 4, number: 617, column_rng: 0..2},
             %{line: 6, number: 592, column_rng: 2..4},
             %{line: 7, number: 755, column_rng: 6..8},
             %{line: 9, number: 664, column_rng: 1..3},
             %{line: 9, number: 598, column_rng: 5..7}
           ]

    assert Enum.sum_by(part_numbers, & &1.number) == 4361
  end

  test "part number ?" do
    engine_map =
      Stream.uniq([
        "467..114..\n",
        "...*......\n",
        "..35...633\n",
        "......#...\n",
        "617*......\n",
        ".....+..58\n",
        "..592.....\n",
        "......755.\n",
        "...$.*....\n",
        ".664.598..\n"
      ])

    part_number_candidates = parse_part_numbers_candidates(engine_map)

    assert Enum.at(part_number_candidates, 0).number == 467
    assert part_number?(Enum.at(part_number_candidates, 0), engine_map) == true

    assert Enum.at(part_number_candidates, 1).number == 114
    assert part_number?(Enum.at(part_number_candidates, 1), engine_map) == false

    assert Enum.at(part_number_candidates, 3).number == 633
    assert part_number?(Enum.at(part_number_candidates, 3), engine_map) == true

    assert Enum.at(part_number_candidates, 5).number == 58
    assert part_number?(Enum.at(part_number_candidates, 5), engine_map) == false
  end

  test "parse gear candidates" do
    engine_map =
      Stream.uniq([
        "467..114..\n",
        "...*......\n",
        "..35...633\n",
        "......#...\n",
        "617*......\n",
        ".....+..58\n",
        "..592.....\n",
        "......755.\n",
        "...$.*....\n",
        ".664.598..\n"
      ])

    gear_candidates = parse_gear_candidates(engine_map)

    assert gear_candidates == [
             %{line: 1, column_rng: 3..3},
             %{line: 4, column_rng: 3..3},
             %{line: 8, column_rng: 5..5}
           ]
  end

  test "gear ?" do
    engine_map =
      Stream.uniq([
        "467..114..\n",
        "...*......\n",
        "..35...633\n",
        "......#...\n",
        "617*......\n",
        ".....+..58\n",
        "..592.....\n",
        "......755.\n",
        "...$.*....\n",
        ".664.598..\n"
      ])

    part_numbers = parse_part_numbers(engine_map)
    gear_candidates = parse_gear_candidates(engine_map)

    assert {true, _} = gear?(Enum.at(gear_candidates, 0), part_numbers)
    assert {false, _} = gear?(Enum.at(gear_candidates, 1), part_numbers)
    assert {true, _} = gear?(Enum.at(gear_candidates, 2), part_numbers)
  end

  test "parse gears" do
    engine_map =
      Stream.uniq([
        "467..114..\n",
        "...*......\n",
        "..35...633\n",
        "......#...\n",
        "617*......\n",
        ".....+..58\n",
        "..592.....\n",
        "......755.\n",
        "...$.*....\n",
        ".664.598..\n"
      ])

    gears = parse_gears(engine_map)

    assert gears == [
             %{
               line: 1,
               column_rng: 3..3,
               part_numbers: [
                 %{line: 0, number: 467, column_rng: 0..2},
                 %{line: 2, number: 35, column_rng: 2..3}
               ]
             },
             %{
               line: 8,
               column_rng: 5..5,
               part_numbers: [
                 %{line: 7, number: 755, column_rng: 6..8},
                 %{line: 9, number: 598, column_rng: 5..7}
               ]
             }
           ]
  end

  test "gear ratio" do
    assert gear_ratio(%{
             line: 1,
             column_rng: 3..3,
             part_numbers: [
               %{line: 0, number: 467, column_rng: 0..2},
               %{line: 2, number: 35, column_rng: 2..3}
             ]
           }) == 16345

    assert gear_ratio(%{
             line: 8,
             column_rng: 5..5,
             part_numbers: [
               %{line: 7, number: 755, column_rng: 6..8},
               %{line: 9, number: 598, column_rng: 5..7}
             ]
           }) == 451_490
  end
end
