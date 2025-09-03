defmodule Day20.PulsePropagation do
  @moduledoc """
  Modules communicate using pulses. Each pulse is either a high pulse or a low pulse. When a module sends a pulse, it sends that type of pulse to each module in its list of destination modules.

  There are several different types of modules:

  - Flip-flop modules (prefix %) are either on or off; they are initially off. If a flip-flop module receives a high pulse, it is ignored and nothing happens. However, if a flip-flop module receives a low pulse, it flips between on and off. If it was off, it turns on and sends a high pulse. If it was on, it turns off and sends a low pulse.
  - Conjunction modules (prefix &) remember the type of the most recent pulse received from each of their connected input modules; they initially default to remembering a low pulse for each input. When a pulse is received, the conjunction module first updates its memory for that input. Then, if it remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends a high pulse.
  - There is a single broadcast module (named broadcaster). When it receives a pulse, it sends the same pulse to all of its destination modules.
  - Here at Desert Machine Headquarters, there is a module with a single button on it called, aptly, the button module. When you push the button, a single low pulse is sent directly to the broadcaster module.

  After pushing the button, you must wait until all pulses have been delivered and fully handled before pushing it again. Never push the button if modules are still processing pulses.

  Pulses are always processed in the order they are sent. So, if a pulse is sent to modules a, b, and c, and then module a processes its pulse and sends more pulses, the pulses sent to modules b and c would have to be handled first.

  The module configuration (your puzzle input) lists each module. The name of the module is preceded by a symbol identifying its type, if any. The name is then followed by an arrow and a list of its destination modules. For example:

  ```
  broadcaster -> a, b, c
  %a -> b
  %b -> c
  %c -> inv
  &inv -> a
  ```
  In this module configuration, the broadcaster has three destination modules named a, b, and c. Each of these modules is a flip-flop module (as indicated by the % prefix). a outputs to b which outputs to c which outputs to another module named inv. inv is a conjunction module (as indicated by the & prefix) which, because it has only one input, acts like an inverter (it sends the opposite of the pulse type it receives); it outputs to a.

  By pushing the button once, the following pulses are sent:

  ```
  button -low-> broadcaster
  broadcaster -low-> a
  broadcaster -low-> b
  broadcaster -low-> c
  a -high-> b
  b -high-> c
  c -high-> inv
  inv -low-> a
  a -low-> b
  b -low-> c
  c -low-> inv
  inv -high-> a
  ```
  After this sequence, the flip-flop modules all end up off, so pushing the button again repeats the same sequence.

  Here's a more interesting example:

  ```
  broadcaster -> a
  %a -> inv, con
  &inv -> b
  %b -> con
  &con -> output
  ```
  This module configuration includes the broadcaster, two flip-flops (named a and b), a single-input conjunction module (inv), a multi-input conjunction module (con), and an untyped module named output (for testing purposes). The multi-input conjunction module con watches the two flip-flop modules and, if they're both on, sends a low pulse to the output module.

  Here's what happens if you push the button once:

  ```
  button -low-> broadcaster
  broadcaster -low-> a
  a -high-> inv
  a -high-> con
  inv -low-> b
  con -high-> output
  b -high-> con
  con -low-> output
  ```
  Both flip-flops turn on and a low pulse is sent to output! However, now that both flip-flops are on and con remembers a high pulse from each of its two inputs, pushing the button a second time does something different:

  ```
  button -low-> broadcaster
  broadcaster -low-> a
  a -low-> inv
  a -low-> con
  inv -high-> b
  con -high-> output
  ```
  Flip-flop a turns off! Now, con remembers a low pulse from module a, and so it sends only a high pulse to output.

  Push the button a third time:

  ```
  button -low-> broadcaster
  broadcaster -low-> a
  a -high-> inv
  a -high-> con
  inv -low-> b
  con -low-> output
  b -low-> con
  con -high-> output
  ```
  This time, flip-flop a turns on, then flip-flop b turns off. However, before b can turn off, the pulse sent to con is handled first, so it briefly remembers all high pulses for its inputs and sends a low pulse to output. After that, flip-flop b turns off, which causes con to update its state and send a high pulse to output.

  Finally, with a on and b off, push the button a fourth time:

  ```
  button -low-> broadcaster
  broadcaster -low-> a
  a -low-> inv
  a -low-> con
  inv -high-> b
  con -high-> output
  ```
  This completes the cycle: a turns off, causing con to remember only low pulses and restoring all modules to their original states.

  To get the cables warmed up, the Elves have pushed the button 1000 times. How many pulses got sent as a result (including the pulses sent by the button itself)?

  In the first example, the same thing happens every time the button is pushed: 8 low pulses and 4 high pulses are sent. So, after pushing the button 1000 times, 8000 low pulses and 4000 high pulses are sent. Multiplying these together gives 32000000.

  In the second example, after pushing the button 1000 times, 4250 low pulses and 2750 high pulses are sent. Multiplying these together gives 11687500.  

  The final machine responsible for moving the sand down to Island Island has a module attached named rx. The machine turns on when a single low pulse is sent to rx.
  """

  def parse_modules(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [module, outputs] = String.split(line, " -> ")
      outputs = String.split(outputs, ", ", trim: true)

      cond do
        module == "broadcaster" ->
          %{
            type: :broadcaster,
            name: "broadcaster",
            outputs: outputs
          }

        String.starts_with?(module, "%") ->
          %{
            type: :flip_flop,
            name: String.slice(module, 1, 100),
            outputs: outputs
          }

        String.starts_with?(module, "&") ->
          %{
            type: :conjunction,
            name: String.slice(module, 1, 100),
            outputs: outputs
          }
      end
    end)
  end

  def init_modules(modules) do
    modules
    |> Enum.map(fn module ->
      module =
        case module.type do
          :flip_flop ->
            Map.put(module, :state, :off)

          :conjunction ->
            inputs =
              modules
              |> Enum.filter(fn %{outputs: outputs} ->
                Enum.member?(outputs, module.name)
              end)
              |> Enum.map(fn %{name: name} -> name end)

            state =
              inputs
              |> Enum.map(fn i -> {i, :low} end)
              |> Enum.into(%{})

            module
            |> Map.put(:inputs, inputs)
            |> Map.put(:state, state)

          _ ->
            module
        end

      {module.name, module}
    end)
    |> Enum.into(%{})
  end

  @doc """
  Generate a graphviz graph of the modules (for Mermaid.js)
  """
  def graph(modules) do
    [
      "flowchart LR"
      | modules
        |> Enum.map(fn {name, module} ->
          %{type: type, outputs: outputs} = module

          [
            case type do
              :broadcaster -> "broadcaster[[broadcaster]]"
              :flip_flop -> "#{name}[/#{name}/]"
              :conjunction -> "#{name}{{#{name}}}"
            end
            | Enum.map(outputs, fn o -> "#{name} --> #{o}" end)
          ]
          |> Enum.join("\n")
        end)
    ]
    |> Enum.join("\n")
  end

  @doc """
  Count the number of button presses required to activate the machine at module `rx`.
  """
  def activate_machine(state) do
    {_, parent_conjunction} =
      Enum.find(state, fn {_, %{outputs: outputs}} -> outputs == ["rx"] end)

    %{name: to, inputs: froms} = parent_conjunction

    first_high_pulse_counts =
      Enum.map(froms, fn from ->
        {from, wait_for_pulse(state, {:high, from, to})}
      end)
      |> Enum.into(%{})

    lcm(first_high_pulse_counts)
  end

  defp lcm(z_indices) do
    z_indices
    |> Map.values()
    |> Enum.reduce(fn a, b -> trunc(a * b / Integer.gcd(a, b)) end)
  end

  defp wait_for_pulse(state, {pulse_type, from, to}) do
    Stream.cycle([1])
    |> Stream.with_index(1)
    |> Enum.reduce_while(state, fn {_, i}, state ->
      # if Integer.mod(i, 1000) == 0, do: IO.puts("Waited #{i} pulses")

      case match_pulse(state, {pulse_type, from, to}) do
        {:ok} -> {:halt, i}
        {:error, new_state} -> {:cont, new_state}
      end
    end)
  end

  defp match_pulse(state, {pulse_type, from, to}) do
    {new_state, all_pulses, _} = propagate_pulses(state)

    if Enum.member?(all_pulses, {pulse_type, from, to}) do
      {:ok}
    else
      {:error, new_state}
    end
  end

  @doc """
  Simulate `count` button presses and propagate all the pulses through the modules.

  Returns 
  - the final modules state
  - the list of all generated pulses
  - the counts of high and low pulses
  """
  def propagate_button_pulse(state, count) do
    1..count
    |> Enum.reduce({state, %{high: 0, low: 0}}, fn _, {state, n_pulses} ->
      {new_state, _, pulses} = propagate_button_pulse(state)
      {new_state, merge_pulses_count(n_pulses, pulses)}
    end)
  end

  @doc """
  Simulate one button press and propagate all the pulses through the modules.

  Returns 
  - the final modules state
  - the list of all generated pulses
  - the counts of high and low pulses
  """
  def propagate_button_pulse(state) do
    propagate_pulses(state)
  end

  defp propagate_pulses(
         state,
         pulses \\ [{:low, nil, "broadcaster"}],
         all_pulses \\ [{:low, nil, "broadcaster"}],
         n_pulses \\ %{high: 0, low: 1}
       ) do
    {new_state, new_pulses} =
      pulses
      |> Enum.reduce({state, []}, fn pulse, {state, new_pulses} ->
        {_, _, to} = pulse
        dst_module = state[to]

        if dst_module == nil do
          {state, new_pulses}
        else
          {new_module_state, add_pulses} =
            propagate_pulse_through_module(dst_module, pulse)

          {
            Map.put(state, dst_module.name, new_module_state),
            new_pulses ++ add_pulses
          }
        end
      end)

    all_pulses = all_pulses ++ new_pulses
    n_pulses = count_pulses(n_pulses, new_pulses)
    # IO.inspect({new_state, new_pulses, n_pulses})

    if new_pulses == [] do
      {new_state, all_pulses, n_pulses}
    else
      propagate_pulses(new_state, new_pulses, all_pulses, n_pulses)
    end
  end

  defp propagate_pulse_through_module(
         module_state = %{type: :broadcaster, name: name, outputs: outputs},
         {pulse_type, _, _}
       ) do
    {
      module_state,
      outputs |> Enum.map(fn o -> {pulse_type, name, o} end)
    }
  end

  defp propagate_pulse_through_module(
         module_state = %{type: :flip_flop},
         {:high, _, _}
       ) do
    {
      module_state,
      []
    }
  end

  defp propagate_pulse_through_module(
         module_state = %{type: :flip_flop, name: name, state: state, outputs: outputs},
         {:low, _, _}
       ) do
    state = if state == :on, do: :off, else: :on
    pulse_type = if state == :on, do: :high, else: :low

    {
      Map.put(module_state, :state, state),
      outputs |> Enum.map(fn o -> {pulse_type, name, o} end)
    }
  end

  defp propagate_pulse_through_module(
         module_state = %{type: :conjunction, name: name, state: state, outputs: outputs},
         {pulse_type, from, _}
       ) do
    state = Map.put(state, from, pulse_type)

    pulse_type =
      if state |> Map.values() |> Enum.all?(fn s -> s == :high end),
        do: :low,
        else: :high

    {
      Map.put(module_state, :state, state),
      outputs |> Enum.map(fn o -> {pulse_type, name, o} end)
    }
  end

  defp merge_pulses_count(a, b) do
    Map.merge(a, b, fn _k, v1, v2 -> v1 + v2 end)
  end

  defp count_pulses(n_pulses, pulses) do
    merge_pulses_count(
      n_pulses,
      Enum.frequencies_by(pulses, fn {type, _, _} -> type end)
    )
  end
end
