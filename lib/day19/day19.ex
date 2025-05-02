defmodule Day19.Day19 do
  use ExUnit.Case

  def run() do
    {parts, workflows} =
      File.read!("lib/day19/input.txt")
      |> Day19.SortMachineParts.parse_parts_and_workflows()

    compiled = Day19.SortMachineParts.compile_accepted_parts(parts, workflows)

    IO.puts("Compiled accepted parts: #{compiled}")
    assert compiled == 409_898

    total_combinations = Day19.SortMachineParts.total_accepted_combinations(workflows)

    IO.puts("Total accepted combinations: #{total_combinations}")
    assert total_combinations == 113_057_405_770_956
  end
end
