defmodule Day15.Day15 do
  use ExUnit.Case

  def run() do
    init_seq =
      File.read!("lib/day15/input.txt")
      |> Day15.InitSequence.parse_init_sequence()

    hashes_sum =
      init_seq
      |> Enum.map(&Day15.InitSequence.hash/1)
      |> Enum.sum()

    IO.puts("Hashes sum: #{hashes_sum}")
    assert hashes_sum == 519_603

    total_focusing_power =
      init_seq
      |> Day15.InitSequence.execute_init_sequence()
      |> Day15.InitSequence.total_focusing_power()

    IO.puts("Total focusing power: #{total_focusing_power}")
    assert total_focusing_power == 244_342
  end
end
