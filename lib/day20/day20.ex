defmodule Day20.Day20 do
  use ExUnit.Case

  def run() do
    modules =
      File.read!("lib/day20/input.txt")
      |> Day20.PulsePropagation.parse_modules()
      |> Day20.PulsePropagation.init_modules()

    IO.puts(Day20.PulsePropagation.graph(modules))

    {_, n_pulses} = Day20.PulsePropagation.propagate_button_pulse(modules, 1000)
    IO.puts("Pulses sent: #{inspect(n_pulses)} product: #{n_pulses.high * n_pulses.low}")
    assert n_pulses.high * n_pulses.low == 898_731_036

    # activation_count = {
    #   Day20.PulsePropagation.wait_for_pulse(modules, {:high, "dc", "ns"}),
    #   Day20.PulsePropagation.wait_for_pulse(modules, {:high, "vp", "ns"}),
    #   Day20.PulsePropagation.wait_for_pulse(modules, {:high, "rv", "ns"}),
    #   Day20.PulsePropagation.wait_for_pulse(modules, {:high, "cq", "ns"}),
    # }
    activation_count = Day20.PulsePropagation.activate_machine(modules)
    IO.puts("Activation count: #{inspect(activation_count)}")
    assert activation_count == 229_414_480_926_893
  end
end
