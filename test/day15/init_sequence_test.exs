defmodule Day15.InitSequenceTest do
  use ExUnit.Case, async: true

  import Day15.InitSequence

  @test_input """
  rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
  """

  test "parse init sequence" do
    assert parse_init_sequence(@test_input) == [
             "rn=1",
             "cm-",
             "qp=3",
             "cm=2",
             "qp-",
             "pc=4",
             "ot=9",
             "ab=5",
             "pc-",
             "pc=6",
             "ot=7"
           ]
  end

  test "HASH algorithm" do
    assert hash("HASH") == 52

    assert parse_init_sequence(@test_input)
           |> Enum.map(&hash/1) == [
             30,
             253,
             97,
             47,
             14,
             180,
             9,
             197,
             48,
             214,
             231
           ]

    assert parse_init_sequence(@test_input)
           |> Enum.map(&hash/1)
           |> Enum.sum() == 1320
  end

  test "decode instruction" do
    assert decode_instruction("rn=1") == {:add, "rn", 1}
    assert decode_instruction("cm-") == {:remove, "cm"}
  end

  test "execute init sequence" do
    assert parse_init_sequence(@test_input)
           |> Enum.take(1)
           |> execute_init_sequence() == %{
             0 => [{"rn", 1}]
           }

    assert parse_init_sequence(@test_input)
           |> Enum.take(2)
           |> execute_init_sequence() == %{
             0 => [{"rn", 1}]
           }

    assert parse_init_sequence(@test_input)
           |> Enum.take(4)
           |> execute_init_sequence() == %{
             0 => [{"rn", 1}, {"cm", 2}],
             1 => [{"qp", 3}]
           }

    assert parse_init_sequence(@test_input)
           |> Enum.take(5)
           |> execute_init_sequence() == %{
             0 => [{"rn", 1}, {"cm", 2}],
             1 => []
           }

    assert parse_init_sequence(@test_input)
           |> execute_init_sequence() == %{
             0 => [{"rn", 1}, {"cm", 2}],
             1 => [],
             3 => [{"ot", 7}, {"ab", 5}, {"pc", 6}]
           }
  end

  test "total focusing power" do
    assert parse_init_sequence(@test_input)
           |> execute_init_sequence()
           |> total_focusing_power() == 145
  end
end
