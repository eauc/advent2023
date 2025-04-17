defmodule Day02.CubeTest do
  use ExUnit.Case, async: true

  import Day02.Cube

  test "parse games" do
    games =
      Stream.uniq([
        "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
        "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
        "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
        "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
        "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
      ])
      |> parse_games()

    assert games == [
             %{id: 1, samples: [%{blue: 3, red: 4}, %{blue: 6, green: 2, red: 1}, %{green: 2}]},
             %{
               id: 2,
               samples: [%{blue: 1, green: 2}, %{blue: 4, green: 3, red: 1}, %{blue: 1, green: 1}]
             },
             %{
               id: 3,
               samples: [
                 %{blue: 6, green: 8, red: 20},
                 %{blue: 5, green: 13, red: 4},
                 %{green: 5, red: 1}
               ]
             },
             %{
               id: 4,
               samples: [
                 %{blue: 6, green: 1, red: 3},
                 %{green: 3, red: 6},
                 %{blue: 15, green: 3, red: 14}
               ]
             },
             %{id: 5, samples: [%{blue: 1, green: 3, red: 6}, %{blue: 2, green: 2, red: 1}]}
           ]
  end

  test "game is possible" do
    total_cubes = %{red: 12, green: 13, blue: 14}

    assert game_possible?(
             %{id: 1, samples: [%{blue: 3, red: 4}, %{blue: 6, green: 2, red: 1}, %{green: 2}]},
             total_cubes
           ) == true

    assert game_possible?(
             %{
               id: 3,
               samples: [
                 %{blue: 6, green: 8, red: 20},
                 %{blue: 5, green: 13, red: 4},
                 %{green: 5, red: 1}
               ]
             },
             total_cubes
           ) == false

    assert game_possible?(
             %{
               id: 4,
               samples: [
                 %{blue: 6, green: 1, red: 3},
                 %{green: 3, red: 6},
                 %{blue: 15, green: 3, red: 14}
               ]
             },
             total_cubes
           ) == false
  end

  test "minimum bag" do
    assert minimum_bag(%{
             id: 1,
             samples: [%{blue: 3, red: 4}, %{blue: 6, green: 2, red: 1}, %{green: 2}]
           }) == %{blue: 6, green: 2, red: 4}

    assert minimum_bag(%{
             id: 3,
             samples: [
               %{blue: 6, green: 8, red: 20},
               %{blue: 5, green: 13, red: 4},
               %{green: 5, red: 1}
             ]
           }) == %{blue: 6, green: 13, red: 20}
  end

  test "cubes set power" do
    assert cubes_set_power(%{blue: 6, green: 2, red: 4}) == 48
    assert cubes_set_power(%{blue: 6, green: 13, red: 20}) == 1560
  end
end
