defmodule Day13.Day13 do
  use ExUnit.Case

  def run() do
    rock_patterns =
      File.read!("lib/day13/input.txt")
      |> Day13.RockPatterns.parse_rock_patterns()

    summary = Day13.RockPatterns.summarize(rock_patterns)
    IO.puts("Rock patterns summary: #{summary}")
    assert summary == 35232

    summary_with_smudge_correction =
      Day13.RockPatterns.summarize_with_smudge_correction(rock_patterns)

    IO.puts("Rock patterns summary with smudge correction: #{summary_with_smudge_correction}")
    assert summary_with_smudge_correction == 37982
  end
end
