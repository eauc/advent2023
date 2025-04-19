defmodule Day07.CamelCards do
  def parse_camel_cards_hands(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ", trim: true)

      %{
        hand: hand,
        bid: String.to_integer(bid)
      }
    end)
  end

  @doc """
  Returns the type of a hand.

  Every hand is exactly one type. From strongest to weakest, they are:

  - Five of a kind, where all five cards have the same label: AAAAA
  - Four of a kind, where four cards have the same label and one card has a different label: AA8AA
  - Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
  - Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
  - Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
  - One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
  - High card, where all cards' labels are distinct: 23456
  """
  def hand_type(hand) do
    freqs =
      hand
      |> String.to_charlist()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort(:desc)

    case freqs do
      [5] -> :five_of_a_kind
      [4 | _] -> :four_of_a_kind
      [3 | [2]] -> :full_house
      [3 | _] -> :three_of_a_kind
      [2 | [2 | _]] -> :two_pairs
      [2 | _] -> :one_pair
      _ -> :high_card
    end
  end

  @doc """
  Returns the type of a hand with joker substitution.

  J cards can pretend to be whatever card is best for the purpose of determining hand type; for example, QJJQ2 is now considered four of a kind.

  The function finds the most common card (beside jokers) and replaces all jokers with that card.
  """
  def hand_type_with_joker(hand) do
    case String.contains?(hand, "J") do
      false ->
        {hand_type(hand), hand}

      true ->
        freqs =
          hand
          |> String.split("", trim: true)
          |> Enum.frequencies()
          |> Enum.reject(fn {card, _} -> card == "J" end)
          |> Enum.sort_by(fn {card, count} -> {count, card_strength(card)} end, :desc)

        {joker_count_as, _} = Enum.at(freqs, 0, {"A", 5})

        new_hand = String.replace(hand, "J", joker_count_as)

        {hand_type(new_hand), new_hand}
    end
  end

  @doc """
  Returns a hand in a string format that can be sorted.

  Each card is replaced by a character that represents its strength, in alphabetical order.
  - digits are unchanged
  - T, J, Q, K, A are replaced by A, B, C, D, E

  A character is prepended to represent the strength of the hand's type.
  - :high_card -> "0"
  - :one_pair -> "A" ...
  - :five_of_a_kind -> "F"
  """
  def sortable_hand(hand, type, card_strength_fn \\ &card_strength/1) do
    case type do
      :high_card -> "0"
      :one_pair -> "A"
      :two_pairs -> "B"
      :three_of_a_kind -> "C"
      :full_house -> "D"
      :four_of_a_kind -> "E"
      :five_of_a_kind -> "F"
    end <>
      String.replace(hand, ~r/[TJQKA]/, card_strength_fn)
  end

  defp card_strength(card) do
    case card do
      "T" -> "A"
      "J" -> "B"
      "Q" -> "C"
      "K" -> "D"
      "A" -> "E"
      _ -> card
    end
  end

  defp card_strength_with_joker(card) do
    case card do
      "J" -> "1"
      _ -> card_strength(card)
    end
  end

  @doc """
  Returns a list of hands sorted and ranked by hand type and strength.

  The weakest hand is first and has rank 1.
  """
  def rank_cards(hands) do
    hands
    |> Enum.map(fn hand ->
      type = hand_type(hand.hand)

      Enum.into(
        [
          type: type,
          sortable_hand: sortable_hand(hand.hand, type)
        ],
        hand
      )
    end)
    |> Enum.sort_by(& &1.sortable_hand)
    |> Enum.with_index(1)
    |> Enum.map(fn {hand, rank} -> Map.put(hand, :rank, rank) end)
  end

  @doc """
  Returns a list of hands sorted and ranked by hand type and strength, with joker substitution.

  The weakest hand is first and has rank 1.
  """
  def rank_cards_with_joker(hands) do
    hands
    |> Enum.map(fn hand ->
      {hand_type, sub_hand} = hand_type_with_joker(hand.hand)

      Enum.into(
        [
          type: hand_type,
          sub_hand: sub_hand,
          sortable_hand: sortable_hand(hand.hand, hand_type, &card_strength_with_joker/1)
        ],
        hand
      )
    end)
    |> Enum.sort_by(& &1.sortable_hand)
    |> Enum.with_index(1)
    |> Enum.map(fn {hand, rank} -> Map.put(hand, :rank, rank) end)
  end
end
