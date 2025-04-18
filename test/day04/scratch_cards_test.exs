defmodule Day04.ScratchCardsTest do
  use ExUnit.Case, async: true

  import Day04.ScratchCards

  test "parse scratch cards" do
    input =
      Stream.uniq([
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\n",
        "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\n",
        "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\n",
        "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\n",
        "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\n",
        "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\n"
      ])

    assert parse_scratch_cards(input) == [
             %{
               id: 1,
               winning_numbers: MapSet.new([41, 48, 83, 86, 17]),
               numbers: MapSet.new([83, 86, 6, 31, 17, 9, 48, 53])
             },
             %{
               id: 2,
               winning_numbers: MapSet.new([13, 32, 20, 16, 61]),
               numbers: MapSet.new([61, 30, 68, 82, 17, 32, 24, 19])
             },
             %{
               id: 3,
               winning_numbers: MapSet.new([1, 21, 53, 59, 44]),
               numbers: MapSet.new([69, 82, 63, 72, 16, 21, 14, 1])
             },
             %{
               id: 4,
               winning_numbers: MapSet.new([41, 92, 73, 84, 69]),
               numbers: MapSet.new([59, 84, 76, 51, 58, 5, 54, 83])
             },
             %{
               id: 5,
               winning_numbers: MapSet.new([87, 83, 26, 28, 32]),
               numbers: MapSet.new([88, 30, 70, 12, 93, 22, 82, 36])
             },
             %{
               id: 6,
               winning_numbers: MapSet.new([31, 18, 13, 56, 72]),
               numbers: MapSet.new([74, 77, 10, 23, 35, 67, 36, 11])
             }
           ]
  end

  test "card score" do
    assert card_score(%{
             id: 1,
             winning_numbers: MapSet.new([41, 48, 83, 86, 17]),
             numbers: MapSet.new([83, 86, 6, 31, 17, 9, 48, 53])
           }) == 8

    assert card_score(%{
             id: 4,
             winning_numbers: MapSet.new([41, 92, 73, 84, 69]),
             numbers: MapSet.new([59, 84, 76, 51, 58, 5, 54, 83])
           }) == 1

    assert card_score(%{
             id: 5,
             winning_numbers: MapSet.new([87, 83, 26, 28, 32]),
             numbers: MapSet.new([88, 30, 70, 12, 93, 22, 82, 36])
           }) == 0

    assert Stream.uniq([
             "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\n",
             "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\n",
             "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\n",
             "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\n",
             "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\n",
             "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\n"
           ])
           |> parse_scratch_cards()
           |> Stream.map(&card_score/1)
           |> Enum.sum() == 13
  end

  test "total cards won" do
    scratch_cards =
      Stream.uniq([
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\n",
        "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\n",
        "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\n",
        "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\n",
        "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\n",
        "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\n"
      ])
      |> parse_scratch_cards()

    assert total_cards_won(scratch_cards) == 30
  end
end
