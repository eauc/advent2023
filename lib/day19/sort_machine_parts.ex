defmodule Day19.SortMachineParts do
  @moduledoc """
  A group of Elves is already here organizing the parts, and they have a system.

  To start, each part is rated in each of four categories:

  - x: Extremely cool looking
  - m: Musical (it makes a noise when you hit it)
  - a: Aerodynamic
  - s: Shiny

  Then, each part is sent through a series of workflows that will ultimately accept or reject the part. Each workflow has a name and contains a list of rules; each rule specifies a condition and where to send the part if the condition is true. The first rule that matches the part being considered is applied immediately, and the part moves on to the destination described by the rule. (The last rule in each workflow has no condition and always applies if reached.)

  Consider the workflow ex{x>10:one,m<20:two,a>30:R,A}. This workflow is named ex and contains four rules. If workflow ex were considering a specific part, it would perform the following steps in order:

  - Rule "x>10:one": If the part's x is more than 10, send the part to the workflow named one.
  - Rule "m<20:two": Otherwise, if the part's m is less than 20, send the part to the workflow named two.
  - Rule "a>30:R": Otherwise, if the part's a is more than 30, the part is immediately rejected (R).
  - Rule "A": Otherwise, because no other rules matched the part, the part is immediately accepted (A).

  If a part is sent to another workflow, it immediately switches to the start of that workflow instead and never returns. If a part is accepted (sent to A) or rejected (sent to R), the part immediately stops any further processing.

  The system works, but it's not keeping up with the torrent of weird metal shapes. The Elves ask if you can help sort a few parts and give you the list of workflows and some part ratings (your puzzle input). For example:

  ```
  px{a<2006:qkq,m>2090:A,rfg}
  pv{a>1716:R,A}
  lnx{m>1548:A,A}
  rfg{s<537:gd,x>2440:R,A}
  qs{s>3448:A,lnx}
  qkq{x<1416:A,crn}
  crn{x>2662:A,R}
  in{s<1351:px,qqz}
  qqz{s>2770:qs,m<1801:hdj,R}
  gd{a>3333:R,R}
  hdj{m>838:A,pv}

  {x=787,m=2655,a=1222,s=2876}
  {x=1679,m=44,a=2067,s=496}
  {x=2036,m=264,a=79,s=2244}
  {x=2461,m=1339,a=466,s=291}
  {x=2127,m=1623,a=2188,s=1013}
  ```
  The workflows are listed first, followed by a blank line, then the ratings of the parts the Elves would like you to sort. All parts begin in the workflow named in. In this example, the five listed parts go through the following workflows:

  ```
  {x=787,m=2655,a=1222,s=2876}: in -> qqz -> qs -> lnx -> A
  {x=1679,m=44,a=2067,s=496}: in -> px -> rfg -> gd -> R
  {x=2036,m=264,a=79,s=2244}: in -> qqz -> hdj -> pv -> A
  {x=2461,m=1339,a=466,s=291}: in -> px -> qkq -> crn -> R
  {x=2127,m=1623,a=2188,s=1013}: in -> px -> rfg -> A
  ```
  Ultimately, three parts are accepted. Adding up the x, m, a, and s rating for each of the accepted parts gives 7540 for the part with x=787, 4623 for the part with x=2036, and 6951 for the part with x=2127. Adding all of the ratings for all of the accepted parts gives the sum total of 19114.

  Each of the four ratings (x, m, a, s) can have an integer value ranging from a minimum of 1 to a maximum of 4000. Of all possible distinct combinations of ratings, your job is to figure out which ones will be accepted.

  In the above example, there are 167409079868000 distinct combinations of ratings that will be accepted.
  """
  @base_combinations %{
    "x" => 1..4000,
    "m" => 1..4000,
    "a" => 1..4000,
    "s" => 1..4000
  }

  def parse_parts_and_workflows(input) do
    [workflows_input, parts_input] = String.split(input, "\n\n", part: 2, trim: true)

    {parse_parts(parts_input), parse_workflows(workflows_input)}
  end

  defp parse_parts(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(["{", "}", ","], trim: true)
      |> Enum.map(fn str -> String.split(str, "=", trim: true) end)
      |> Enum.map(fn [key, value] -> {key, String.to_integer(value)} end)
      |> Enum.into(%{})
    end)
  end

  defp parse_workflows(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [name | rules] =
        String.split(line, ["{", "}", ","], trim: true)

      {
        name,
        rules
        |> Enum.map(fn str ->
          case String.split(str, ":", trim: true) do
            [cmp, dst] ->
              [key, comparator, threshold_str] =
                Regex.run(~r/^([xmas])([<>])(\d+)$/, cmp, capture: :all_but_first)

              threshold = String.to_integer(threshold_str)

              {{key, comparator, threshold}, dst}

            [dst] ->
              {nil, dst}
          end
        end)
        |> Enum.map(fn {cmp_fn, dst_str} ->
          {cmp_fn,
           case dst_str do
             "R" -> :rejected
             "A" -> :accepted
             _ -> dst_str
           end}
        end)
      }
    end)
    |> Enum.into(%{})
  end

  @doc """
  Determines whether a part is accepted or rejected.

  Resolves the workflows on the given part, and returns `:accepted` or `:rejected`.
  """
  def accept_or_reject_part(part, workflows) do
    accept_or_reject_part(part, "in", workflows)
  end

  defp accept_or_reject_part(_, :accepted, _), do: :accepted
  defp accept_or_reject_part(_, :rejected, _), do: :rejected

  defp accept_or_reject_part(part, current_workflow, workflows) do
    {_, next_workflow} =
      workflows[current_workflow]
      |> Enum.find(fn {cmp, _} ->
        case cmp do
          nil ->
            true

          {key, comparator, threshold} ->
            case comparator do
              ">" -> Map.get(part, key) > threshold
              "<" -> Map.get(part, key) < threshold
            end
        end
      end)

    accept_or_reject_part(part, next_workflow, workflows)
  end

  @doc """
  Compiles the sum of all accepted parts values.
  """
  def compile_accepted_parts(parts, workflows) do
    parts
    |> Enum.filter(&(accept_or_reject_part(&1, workflows) == :accepted))
    |> Enum.sum_by(fn part -> Enum.sum(Map.values(part)) end)
  end

  @doc """
  Computes the total number of accepted part combinations.
  """
  def total_accepted_combinations(workflows) do
    rule_ranges =
      workflows
      |> rule_ranges()

    rule_ranges
    |> Enum.filter(fn %{dst: dst} -> dst == :accepted end)
    |> Enum.map(&accepted_rule_combinations(&1, rule_ranges))
    |> Enum.map(fn combinations ->
      combinations
      |> Map.values()
      |> Enum.product_by(&Range.size/1)
    end)
    |> Enum.sum()
  end

  defp rule_ranges(workflows) do
    workflows
    |> Enum.flat_map(fn {wname, rules} ->
      rules =
        rules
        |> Enum.map(fn {cmp, dst} ->
          case cmp do
            nil ->
              %{
                workflow: wname,
                accept: %{},
                reject: %{},
                dst: dst
              }

            {key, comparator, threshold} ->
              %{
                workflow: wname,
                accept:
                  [
                    {key,
                     case comparator do
                       ">" -> (threshold + 1)..4000
                       "<" -> 0..(threshold - 1)
                     end}
                  ]
                  |> Enum.into(%{}),
                reject:
                  [
                    {key,
                     case comparator do
                       ">" -> 0..threshold
                       "<" -> threshold..4000
                     end}
                  ]
                  |> Enum.into(%{}),
                dst: dst
              }
          end
        end)

      rules
      |> Enum.with_index()
      |> Enum.map(fn {rule, index} ->
        Map.update(rule, :accept, %{}, fn accept ->
          rules
          |> Enum.take(index)
          |> Enum.map(&Map.get(&1, :reject))
          |> Enum.reduce(
            accept,
            &merge_combinations(&2, &1)
          )
        end)
      end)
    end)
  end

  defp accepted_rule_combinations(rule, rule_ranges, combinations \\ @base_combinations) do
    %{accept: accept, workflow: workflow} = rule

    case workflow do
      "in" ->
        merge_combinations(combinations, accept)

      _ ->
        [new_rule] = Enum.filter(rule_ranges, &(&1.dst == rule.workflow))

        accepted_rule_combinations(
          new_rule,
          rule_ranges,
          merge_combinations(combinations, accept)
        )
    end
  end

  defp merge_combinations(c1, c2) do
    Map.merge(c1, c2, fn _, r1, r2 ->
      merge_ranges(r1, r2)
    end)
  end

  defp merge_ranges(r1, r2) do
    if Range.disjoint?(r1, r2) do
      nil
    else
      min1..max1//_ = r1
      min2..max2//_ = r2
      min = max(min1, min2)
      max = min(max1, max2)
      min..max
    end
  end
end
