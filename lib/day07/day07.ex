defmodule Day07.Day07 do
  use ExUnit.Case

  def run() do
    camel_cards =
      File.read!("lib/day07/input.txt")
      |> Day07.CamelCards.parse_camel_cards_hands()

    total_winnings =
      camel_cards
      |> Day07.CamelCards.rank_cards()
      |> Enum.sum_by(fn %{bid: bid, rank: rank} -> bid * rank end)

    IO.puts("Total winnings: #{total_winnings}")
    assert total_winnings == 251_287_184

    total_winnings_with_joker =
      camel_cards
      |> Day07.CamelCards.rank_cards_with_joker()
      |> Enum.sum_by(fn %{bid: bid, rank: rank} -> bid * rank end)

    IO.puts("Total winnings with joker: #{total_winnings_with_joker}")
    assert total_winnings_with_joker == 250_757_288
  end
end
