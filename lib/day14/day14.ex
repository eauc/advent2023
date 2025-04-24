defmodule Day14.Day14 do
  use ExUnit.Case

  def run() do
    map =
      File.read!("lib/day14/input.txt")
      |> Day14.ParabolicReflector.parse_platform_map()

    total_load =
      map
      |> Day14.ParabolicReflector.tilt_north()
      |> Day14.ParabolicReflector.total_load()

    IO.puts("total load: #{total_load}")
    assert total_load == 103333

    total_load_1G_cycles =
      map
      |> Day14.ParabolicReflector.cycle(1_000_000_000)
      |> Day14.ParabolicReflector.total_load()

    IO.puts("total load after 1G cycles: #{total_load_1G_cycles}")
    assert total_load_1G_cycles == 97241
  end
end
