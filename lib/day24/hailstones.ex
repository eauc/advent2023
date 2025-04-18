defmodule Day24.Hailstones do
  @moduledoc """
  It seems like something is going wrong with the snow-making process. Instead of forming snow, the water that's been absorbed into the air seems to be forming hail!

  Maybe there's something you can do to break up the hailstones?

  Due to strong, probably-magical winds, the hailstones are all flying through the air in perfectly linear trajectories. You make a note of each hailstone's position and velocity (your puzzle input). For example:

  ```
  19, 13, 30 @ -2,  1, -2
  18, 19, 22 @ -1, -1, -2
  20, 25, 34 @ -2, -2, -4
  12, 31, 28 @ -1, -2, -1
  20, 19, 15 @  1, -5, -3
  ```
  Each line of text corresponds to the position and velocity of a single hailstone. The positions indicate where the hailstones are right now (at time 0). The velocities are constant and indicate exactly how far each hailstone will move in one nanosecond.

  Each line of text uses the format px py pz @ vx vy vz. For instance, the hailstone specified by 20, 19, 15 @ 1, -5, -3 has initial X position 20, Y position 19, Z position 15, X velocity 1, Y velocity -5, and Z velocity -3. After one nanosecond, the hailstone would be at 21, 14, 12.

  Perhaps you won't have to do anything. How likely are the hailstones to collide with each other and smash into tiny ice crystals?

  To estimate this, consider only the X and Y axes; ignore the Z axis. Looking forward in time, how many of the hailstones' paths will intersect within a test area? (The hailstones themselves don't have to collide, just test for intersections between the paths they will trace.)

  In this example, look for intersections that happen with an X and Y position each at least 7 and at most 27; in your actual data, you'll need to check a much larger test area. Comparing all pairs of hailstones' future paths produces the following results:

  ```
  Hailstone A: 19, 13, 30 @ -2, 1, -2
  Hailstone B: 18, 19, 22 @ -1, -1, -2
  Hailstones' paths will cross inside the test area (at x=14.333, y=15.333).

  Hailstone A: 19, 13, 30 @ -2, 1, -2
  Hailstone B: 20, 25, 34 @ -2, -2, -4
  Hailstones' paths will cross inside the test area (at x=11.667, y=16.667).

  Hailstone A: 19, 13, 30 @ -2, 1, -2
  Hailstone B: 12, 31, 28 @ -1, -2, -1
  Hailstones' paths will cross outside the test area (at x=6.2, y=19.4).

  Hailstone A: 19, 13, 30 @ -2, 1, -2
  Hailstone B: 20, 19, 15 @ 1, -5, -3
  Hailstones' paths crossed in the past for hailstone A.

  Hailstone A: 18, 19, 22 @ -1, -1, -2
  Hailstone B: 20, 25, 34 @ -2, -2, -4
  Hailstones' paths are parallel; they never intersect.

  Hailstone A: 18, 19, 22 @ -1, -1, -2
  Hailstone B: 12, 31, 28 @ -1, -2, -1
  Hailstones' paths will cross outside the test area (at x=-6, y=-5).

  Hailstone A: 18, 19, 22 @ -1, -1, -2
  Hailstone B: 20, 19, 15 @ 1, -5, -3
  Hailstones' paths crossed in the past for both hailstones.

  Hailstone A: 20, 25, 34 @ -2, -2, -4
  Hailstone B: 12, 31, 28 @ -1, -2, -1
  Hailstones' paths will cross outside the test area (at x=-2, y=3).

  Hailstone A: 20, 25, 34 @ -2, -2, -4
  Hailstone B: 20, 19, 15 @ 1, -5, -3
  Hailstones' paths crossed in the past for hailstone B.

  Hailstone A: 12, 31, 28 @ -1, -2, -1
  Hailstone B: 20, 19, 15 @ 1, -5, -3
  Hailstones' paths crossed in the past for both hailstones.
  ```
  So, in this example, 2 hailstones' future paths cross inside the boundaries of the test area.
  """

  def parse_hailstones(input) do
    input
    |> Stream.map(fn line ->
      [pos_str, vel_str] =
        line
        |> String.trim()
        |> String.split(~r/\s*@\s*/)

      [px, py, pz] =
        pos_str
        |> String.split(~r/\s*,\s*/)
        |> Enum.map(&String.to_integer/1)

      [vx, vy, vz] =
        vel_str
        |> String.split(~r/\s*,\s*/)
        |> Enum.map(&String.to_integer/1)

      %{
        position: {px, py, pz},
        velocity: {vx, vy, vz}
      }
    end)
    |> Enum.to_list()
  end

  def hailstones_crosses_within_area(hailstones, {x_min, x_max}, {y_min, y_max}) do
    hailstones
    |> Stream.with_index()
    |> Stream.map(fn {hailstone_a, index} ->
      hailstones
      |> Stream.drop(index + 1)
      |> Stream.map(fn hailstone_b ->
        case hailstones_cross?(hailstone_a, hailstone_b) do
          # ignore crosses in the past
          %{ta: ta, tb: tb} when ta < 0 or tb < 0 ->
            nil

          # ignore crosses outside the area
          %{position: {px, py, _}} when px < x_min or px > x_max or py < y_min or py > y_max ->
            nil

          # ignore don't cross
          nil ->
            nil

          cross ->
            {hailstone_a, hailstone_b, cross}
        end
      end)
    end)
    |> Stream.concat()
    |> Stream.filter(&(&1 != nil))
    |> Enum.to_list()
  end

  def hailstones_cross?(hailstone_a, hailstone_b) do
    %{position: {apx, apy, _}, velocity: {avx, avy, _}} = hailstone_a
    %{position: {bpx, bpy, _}, velocity: {bvx, bvy, _}} = hailstone_b
    det = avx - avy * bvx / bvy

    case det do
      0.0 ->
        nil

      det ->
        ta = (bpx - apx + (apy - bpy) * bvx / bvy) / det
        tb = (apx - bpx + ta * avx) / bvx

        %{
          ta: ta,
          tb: tb,
          position: {ta * avx + apx, ta * avy + apy, 0}
        }
    end
  end
end
