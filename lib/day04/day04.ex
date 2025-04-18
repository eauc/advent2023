defmodule Day04.Day04 do
  use ExUnit.Case

  def run() do
    scratch_cards =
      File.stream!("lib/day04/input.txt")
      |> Day04.ScratchCards.parse_scratch_cards()

    total_score =
      scratch_cards
      |> Enum.map(&Day04.ScratchCards.card_score/1)
      |> Enum.sum()

    IO.puts("Scratch cards total worth: #{total_score}")
    assert total_score == 18619

    total_cards_won =
      scratch_cards
      |> Day04.ScratchCards.total_cards_won()

    IO.puts("Total cards won: #{total_cards_won}")
  end
end
