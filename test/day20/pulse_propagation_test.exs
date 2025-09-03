defmodule Day20.PulsePropagationTest do
  use ExUnit.Case, async: true

  import Day20.PulsePropagation

  @test_input_1 """
  broadcaster -> a, b, c
  %a -> b
  %b -> c
  %c -> inv
  &inv -> a
  """

  @test_input_2 """
  broadcaster -> a
  %a -> inv, con
  &inv -> b
  %b -> con
  &con -> output
  """

  test "parse and init modules states" do
    assert @test_input_1
           |> parse_modules()
           |> init_modules() == %{
             "a" => %{name: "a", type: :flip_flop, state: :off, outputs: ["b"]},
             "b" => %{name: "b", type: :flip_flop, state: :off, outputs: ["c"]},
             "broadcaster" => %{
               name: "broadcaster",
               type: :broadcaster,
               outputs: ["a", "b", "c"]
             },
             "c" => %{name: "c", type: :flip_flop, state: :off, outputs: ["inv"]},
             "inv" => %{
               name: "inv",
               type: :conjunction,
               state: %{"c" => :low},
               outputs: ["a"],
               inputs: ["c"]
             }
           }

    assert @test_input_2
           |> parse_modules()
           |> init_modules() == %{
             "a" => %{name: "a", type: :flip_flop, state: :off, outputs: ["inv", "con"]},
             "b" => %{name: "b", type: :flip_flop, state: :off, outputs: ["con"]},
             "broadcaster" => %{name: "broadcaster", type: :broadcaster, outputs: ["a"]},
             "con" => %{
               name: "con",
               type: :conjunction,
               state: %{"a" => :low, "b" => :low},
               outputs: ["output"],
               inputs: ["a", "b"]
             },
             "inv" => %{
               name: "inv",
               type: :conjunction,
               state: %{"a" => :low},
               outputs: ["b"],
               inputs: ["a"]
             }
           }
  end

  test "graph" do
    modules_1 =
      @test_input_1
      |> parse_modules()
      |> init_modules()

    assert graph(modules_1) <> "\n" == """
           flowchart LR
           a[/a/]
           a --> b
           b[/b/]
           b --> c
           broadcaster[[broadcaster]]
           broadcaster --> a
           broadcaster --> b
           broadcaster --> c
           c[/c/]
           c --> inv
           inv{{inv}}
           inv --> a
           """
  end

  test "propagate pulses" do
    modules_1 =
      @test_input_1
      |> parse_modules()
      |> init_modules()

    assert propagate_button_pulse(modules_1) == {
             %{
               "a" => %{name: "a", type: :flip_flop, state: :off, outputs: ["b"]},
               "b" => %{name: "b", type: :flip_flop, state: :off, outputs: ["c"]},
               "broadcaster" => %{
                 name: "broadcaster",
                 type: :broadcaster,
                 outputs: ["a", "b", "c"]
               },
               "c" => %{name: "c", type: :flip_flop, state: :off, outputs: ["inv"]},
               "inv" => %{
                 name: "inv",
                 type: :conjunction,
                 state: %{"c" => :low},
                 outputs: ["a"],
                 inputs: ["c"]
               }
             },
             [
               {:low, nil, "broadcaster"},
               {:low, "broadcaster", "a"},
               {:low, "broadcaster", "b"},
               {:low, "broadcaster", "c"},
               {:high, "a", "b"},
               {:high, "b", "c"},
               {:high, "c", "inv"},
               {:low, "inv", "a"},
               {:low, "a", "b"},
               {:low, "b", "c"},
               {:low, "c", "inv"},
               {:high, "inv", "a"}
             ],
             %{high: 4, low: 8}
           }

    modules_2 =
      @test_input_2
      |> parse_modules()
      |> init_modules()

    assert propagate_button_pulse(modules_2) == {
             %{
               "a" => %{name: "a", type: :flip_flop, state: :on, outputs: ["inv", "con"]},
               "b" => %{name: "b", type: :flip_flop, state: :on, outputs: ["con"]},
               "broadcaster" => %{name: "broadcaster", type: :broadcaster, outputs: ["a"]},
               "con" => %{
                 name: "con",
                 type: :conjunction,
                 state: %{"a" => :high, "b" => :high},
                 outputs: ["output"],
                 inputs: ["a", "b"]
               },
               "inv" => %{
                 name: "inv",
                 type: :conjunction,
                 state: %{"a" => :high},
                 outputs: ["b"],
                 inputs: ["a"]
               }
             },
             [
               {:low, nil, "broadcaster"},
               {:low, "broadcaster", "a"},
               {:high, "a", "inv"},
               {:high, "a", "con"},
               {:low, "inv", "b"},
               {:high, "con", "output"},
               {:high, "b", "con"},
               {:low, "con", "output"}
             ],
             %{high: 4, low: 4}
           }
  end

  test "propagate button pulse n times" do
    modules_1 =
      @test_input_1
      |> parse_modules()
      |> init_modules()

    {state, n_pulses} = propagate_button_pulse(modules_1, 1000)
    assert state == modules_1
    assert n_pulses == %{high: 4000, low: 8000}

    modules_2 =
      @test_input_2
      |> parse_modules()
      |> init_modules()

    {state, n_pulses} = propagate_button_pulse(modules_2, 4)
    assert state == modules_2
    assert n_pulses == %{high: 11, low: 17}

    {state, n_pulses} = propagate_button_pulse(modules_2, 1000)
    assert state == modules_2
    assert n_pulses == %{high: 2750, low: 4250}
  end
end
