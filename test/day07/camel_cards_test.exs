defmodule Day07.CamelCardsTest do
  use ExUnit.Case, async: true
  import Day07.CamelCards

  @test_input """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  test "parse camel cards hands" do
    assert parse_camel_cards_hands(@test_input) == [
             %{
               hand: "32T3K",
               bid: 765
             },
             %{
               hand: "T55J5",
               bid: 684
             },
             %{
               hand: "KK677",
               bid: 28
             },
             %{
               hand: "KTJJT",
               bid: 220
             },
             %{
               hand: "QQQJA",
               bid: 483
             }
           ]
  end

  test "hand type" do
    assert hand_type("32T4K") == :high_card
    assert hand_type("32T3K") == :one_pair
    assert hand_type("32T32") == :two_pairs
    assert hand_type("T55J5") == :three_of_a_kind
    assert hand_type("T55T5") == :full_house
    assert hand_type("T5555") == :four_of_a_kind
    assert hand_type("55555") == :five_of_a_kind
  end

  test "hand type with joker" do
    # no joker -> same type as normal
    assert hand_type_with_joker("32T4K") == {:high_card, "32T4K"}
    assert hand_type_with_joker("32T3K") == {:one_pair, "32T3K"}
    assert hand_type_with_joker("32T32") == {:two_pairs, "32T32"}
    assert hand_type_with_joker("T55Q5") == {:three_of_a_kind, "T55Q5"}
    assert hand_type_with_joker("T55T5") == {:full_house, "T55T5"}
    assert hand_type_with_joker("T5555") == {:four_of_a_kind, "T5555"}
    assert hand_type_with_joker("55555") == {:five_of_a_kind, "55555"}

    # :four_of_a_kind with one joker
    assert hand_type_with_joker("55J55") == {:five_of_a_kind, "55555"}
    # :three_of_a_kind with one joker
    assert hand_type_with_joker("5QJ55") == {:four_of_a_kind, "5Q555"}
    # :three_of_a_kind with two joker
    assert hand_type_with_joker("5JJ55") == {:five_of_a_kind, "55555"}
    # :two_pairs with one joker
    assert hand_type_with_joker("5QJQ5") == {:full_house, "5QQQ5"}
    # :one_pair with one joker
    assert hand_type_with_joker("5QJK5") == {:three_of_a_kind, "5Q5K5"}
    # :one_pair with two jokers
    assert hand_type_with_joker("5QJJ5") == {:four_of_a_kind, "5Q555"}
    # :one_pair with three jokers
    assert hand_type_with_joker("5JJJ5") == {:five_of_a_kind, "55555"}
    # :high_card with one joker
    assert hand_type_with_joker("5QJKT") == {:one_pair, "5QKKT"}
    # :high_card with two jokers
    assert hand_type_with_joker("5JJKT") == {:three_of_a_kind, "5KKKT"}
    # :high_card with three jokers
    assert hand_type_with_joker("5JJKJ") == {:four_of_a_kind, "5KKKK"}
    # :high_card with fours jokers
    assert hand_type_with_joker("JJJKJ") == {:five_of_a_kind, "KKKKK"}
  end

  test "sortable hand" do
    assert sortable_hand("23456", :high_card) == "023456"
    assert sortable_hand("789TJ", :one_pair) == "A789AB"
    assert sortable_hand("TJQKA", :two_pairs) == "BABCDE"
    assert sortable_hand("23456", :three_of_a_kind) == "C23456"
    assert sortable_hand("23456", :full_house) == "D23456"
    assert sortable_hand("23456", :four_of_a_kind) == "E23456"
    assert sortable_hand("23456", :five_of_a_kind) == "F23456"
  end

  test "rank cards" do
    assert @test_input
           |> parse_camel_cards_hands()
           |> rank_cards() == [
             %{
               hand: "32T3K",
               type: :one_pair,
               sortable_hand: "A32A3D",
               rank: 1,
               bid: 765
             },
             %{
               hand: "KTJJT",
               type: :two_pairs,
               sortable_hand: "BDABBA",
               rank: 2,
               bid: 220
             },
             %{
               hand: "KK677",
               type: :two_pairs,
               sortable_hand: "BDD677",
               rank: 3,
               bid: 28
             },
             %{
               hand: "T55J5",
               type: :three_of_a_kind,
               sortable_hand: "CA55B5",
               rank: 4,
               bid: 684
             },
             %{
               hand: "QQQJA",
               type: :three_of_a_kind,
               sortable_hand: "CCCCBE",
               rank: 5,
               bid: 483
             }
           ]

    assert @test_input
           |> parse_camel_cards_hands()
           |> rank_cards()
           |> Enum.sum_by(fn %{bid: bid, rank: rank} -> bid * rank end) == 6440
  end

  test "rank cards with joker" do
    assert @test_input
           |> parse_camel_cards_hands()
           |> rank_cards_with_joker() == [
             %{
               hand: "32T3K",
               sub_hand: "32T3K",
               type: :one_pair,
               sortable_hand: "A32A3D",
               rank: 1,
               bid: 765
             },
             %{
               hand: "KK677",
               sub_hand: "KK677",
               type: :two_pairs,
               sortable_hand: "BDD677",
               rank: 2,
               bid: 28
             },
             %{
               hand: "T55J5",
               sub_hand: "T5555",
               type: :four_of_a_kind,
               sortable_hand: "EA5515",
               rank: 3,
               bid: 684
             },
             %{
               hand: "QQQJA",
               sub_hand: "QQQQA",
               type: :four_of_a_kind,
               sortable_hand: "ECCC1E",
               rank: 4,
               bid: 483
             },
             %{
               hand: "KTJJT",
               sub_hand: "KTTTT",
               type: :four_of_a_kind,
               sortable_hand: "EDA11A",
               rank: 5,
               bid: 220
             },
           ]

    assert @test_input
           |> parse_camel_cards_hands()
           |> rank_cards_with_joker()
           |> Enum.sum_by(fn %{bid: bid, rank: rank} -> bid * rank end) == 5905
  end
end
