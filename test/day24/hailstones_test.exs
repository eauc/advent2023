defmodule Day24.HailstonesTest do
  use ExUnit.Case, async: true

  import Day04.Hailstones

  test "parse hailstones" do
    input =
      Stream.uniq([
        "19, 13, 30 @ -2,  1, -2\n",
        "18, 19, 22 @ -1, -1, -2\n",
        "20, 25, 34 @ -2, -2, -4\n",
        "12, 31, 28 @ -1, -2, -1\n",
        "20, 19, 15 @  1, -5, -3\n"
      ])

    assert parse_hailstones(input) == [
             %{
               position: {19, 13, 30},
               velocity: {-2, 1, -2}
             },
             %{
               position: {18, 19, 22},
               velocity: {-1, -1, -2}
             },
             %{
               position: {20, 25, 34},
               velocity: {-2, -2, -4}
             },
             %{
               position: {12, 31, 28},
               velocity: {-1, -2, -1}
             },
             %{
               position: {20, 19, 15},
               velocity: {1, -5, -3}
             }
           ]
  end

  test "hailstones cross?" do
    # Hailstone A: 19, 13, 30 @ -2, 1, -2
    # Hailstone B: 18, 19, 22 @ -1, -1, -2
    # Hailstones' paths will cross inside the test area (at x=14.333, y=15.333).
    assert hailstones_cross?(
             %{
               position: {19, 13, 30},
               velocity: {-2, 1, -2}
             },
             %{
               position: {18, 19, 22},
               velocity: {-1, -1, -2}
             }
           ) == %{
             ta: 2.3333333333333335,
             tb: 3.666666666666667,
             position: {14.333333333333332, 15.333333333333334, 0}
           }

    # Hailstone A: 19, 13, 30 @ -2, 1, -2
    # Hailstone B: 20, 25, 34 @ -2, -2, -4
    # Hailstones' paths will cross inside the test area (at x=11.667, y=16.667)
    assert hailstones_cross?(
             %{
               position: {19, 13, 30},
               velocity: {-2, 1, -2}
             },
             %{
               position: {20, 25, 34},
               velocity: {-2, -2, -4}
             }
           ) == %{
             ta: 3.6666666666666665,
             tb: 4.166666666666666,
             position: {11.666666666666668, 16.666666666666668, 0}
           }

    # Hailstone A: 19, 13, 30 @ -2, 1, -2
    # Hailstone B: 12, 31, 28 @ -1, -2, -1
    # Hailstones' paths will cross outside the test area (at x=6.2, y=19.4).
    assert hailstones_cross?(
             %{
               position: {19, 13, 30},
               velocity: {-2, 1, -2}
             },
             %{
               position: {12, 31, 28},
               velocity: {-1, -2, -1}
             }
           ) == %{
             ta: 6.4,
             tb: 5.800000000000001,
             position: {6.199999999999999, 19.4, 0}
           }

    # Hailstone A: 19, 13, 30 @ -2, 1, -2
    # Hailstone B: 20, 19, 15 @ 1, -5, -3
    # Hailstones' paths crossed in the past for hailstone A.
    assert hailstones_cross?(
             %{
               position: {19, 13, 30},
               velocity: {-2, 1, -2}
             },
             %{
               position: {20, 19, 15},
               velocity: {1, -5, -3}
             }
           ) == %{
             ta: -1.22222222222222223,
             tb: 1.4444444444444446,
             position: {21.444444444444443, 11.777777777777779, 0}
           }

    # Hailstone A: 18, 19, 22 @ -1, -1, -2
    # Hailstone B: 20, 25, 34 @ -2, -2, -4
    # Hailstones' paths are parallel; they never intersect.
    assert hailstones_cross?(
             %{
               position: {18, 19, 22},
               velocity: {-1, -1, -2}
             },
             %{
               position: {20, 25, 34},
               velocity: {-2, -2, -4}
             }
           ) == nil

    # Hailstone A: 18, 19, 22 @ -1, -1, -2
    # Hailstone B: 12, 31, 28 @ -1, -2, -1
    # Hailstones' paths will cross outside the test area (at x=-6, y=-5).
    assert hailstones_cross?(
             %{
               position: {18, 19, 22},
               velocity: {-1, -1, -2}
             },
             %{
               position: {12, 31, 28},
               velocity: {-1, -2, -1}
             }
           ) == %{
             ta: 24.0,
             tb: 18.0,
             position: {-6.0, -5.0, 0}
           }

    # Hailstone A: 18, 19, 22 @ -1, -1, -2
    # Hailstone B: 20, 19, 15 @ 1, -5, -3
    # Hailstones' paths crossed in the past for both hailstones.
    assert hailstones_cross?(
             %{
               position: {18, 19, 22},
               velocity: {-1, -1, -2}
             },
             %{
               position: {20, 19, 15},
               velocity: {1, -5, -3}
             }
           ) == %{
             ta: -1.66666666666666667,
             tb: -0.33333333333333326,
             position: {19.666666666666667, 20.666666666666667, 0}
           }

    # Hailstone A: 20, 25, 34 @ -2, -2, -4
    # Hailstone B: 12, 31, 28 @ -1, -2, -1
    # Hailstones' paths will cross outside the test area (at x=-2, y=3).
    assert hailstones_cross?(
             %{
               position: {20, 25, 34},
               velocity: {-2, -2, -4}
             },
             %{
               position: {12, 31, 28},
               velocity: {-1, -2, -1}
             }
           ) == %{
             ta: 11.0,
             tb: 14.0,
             position: {-2.0, 3.0, 0}
           }

    # Hailstone A: 20, 25, 34 @ -2, -2, -4
    # Hailstone B: 20, 19, 15 @ 1, -5, -3
    # Hailstones' paths crossed in the past for hailstone B.
    assert hailstones_cross?(
             %{
               position: {20, 25, 34},
               velocity: {-2, -2, -4}
             },
             %{
               position: {20, 19, 15},
               velocity: {1, -5, -3}
             }
           ) == %{
             ta: 0.5,
             tb: -1.0,
             position: {19.0, 24.0, 0}
           }

    # Hailstone A: 12, 31, 28 @ -1, -2, -1
    # Hailstone B: 20, 19, 15 @ 1, -5, -3
    # Hailstones' paths crossed in the past for both hailstones.
    assert hailstones_cross?(
             %{
               position: {12, 31, 28},
               velocity: {-1, -2, -1}
             },
             %{
               position: {20, 19, 15},
               velocity: {1, -5, -3}
             }
           ) == %{
             ta: -4.0,
             tb: -4.0,
             position: {16.0, 39.0, 0}
           }
  end

  test "hailstones cross with area" do
    hailstones =
      Stream.uniq([
        "19,13,30 @ -2,1,-2",
        "20,25,34 @ -2,-2,-4",
        "18,19,22 @ -1,-1,-2",
        "12,31,28 @ -1,-2,-1",
        "20,19,15 @ 1,-5,-3"
      ])
      |> parse_hailstones()

    assert hailstones_crosses_within_area(hailstones, {7, 27}, {7, 27}) == [
             {
               %{position: {19, 13, 30}, velocity: {-2, 1, -2}},
               %{position: {20, 25, 34}, velocity: {-2, -2, -4}},
               %{
                 ta: 3.6666666666666665,
                 tb: 4.166666666666666,
                 position: {11.666666666666668, 16.666666666666668, 0}
               }
             },
             {
               %{position: {19, 13, 30}, velocity: {-2, 1, -2}},
               %{position: {18, 19, 22}, velocity: {-1, -1, -2}},
               %{
                 ta: 2.3333333333333335,
                 tb: 3.666666666666667,
                 position: {14.333333333333332, 15.333333333333334, 0}
               }
             }
           ]
  end
end
