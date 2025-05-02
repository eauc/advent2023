defmodule Day19.SortMachinePartsTest do
  use ExUnit.Case, async: true

  import Day19.SortMachineParts

  @test_input """
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
  """

  test "parse parts and workflow" do
    {parts, workflows} = parse_parts_and_workflows(@test_input)

    assert parts == [
             %{"a" => 1222, "m" => 2655, "s" => 2876, "x" => 787},
             %{"a" => 2067, "m" => 44, "s" => 496, "x" => 1679},
             %{"a" => 79, "m" => 264, "s" => 2244, "x" => 2036},
             %{"a" => 466, "m" => 1339, "s" => 291, "x" => 2461},
             %{"a" => 2188, "m" => 1623, "s" => 1013, "x" => 2127}
           ]

    assert workflows == %{
             "crn" => [{{"x", ">", 2662}, :accepted}, {nil, :rejected}],
             "gd" => [{{"a", ">", 3333}, :rejected}, {nil, :rejected}],
             "hdj" => [{{"m", ">", 838}, :accepted}, {nil, "pv"}],
             "in" => [{{"s", "<", 1351}, "px"}, {nil, "qqz"}],
             "lnx" => [{{"m", ">", 1548}, :accepted}, {nil, :accepted}],
             "pv" => [{{"a", ">", 1716}, :rejected}, {nil, :accepted}],
             "px" => [
               {{"a", "<", 2006}, "qkq"},
               {{"m", ">", 2090}, :accepted},
               {nil, "rfg"}
             ],
             "qkq" => [{{"x", "<", 1416}, :accepted}, {nil, "crn"}],
             "qqz" => [
               {{"s", ">", 2770}, "qs"},
               {{"m", "<", 1801}, "hdj"},
               {nil, :rejected}
             ],
             "qs" => [{{"s", ">", 3448}, :accepted}, {nil, "lnx"}],
             "rfg" => [
               {{"s", "<", 537}, "gd"},
               {{"x", ">", 2440}, :rejected},
               {nil, :accepted}
             ]
           }
  end

  test "accept or reject part" do
    {parts, workflows} = parse_parts_and_workflows(@test_input)

    assert Enum.map(parts, &accept_or_reject_part(&1, workflows)) == [
             :accepted,
             :rejected,
             :accepted,
             :rejected,
             :accepted
           ]

    assert compile_accepted_parts(parts, workflows) == 19114
  end

  test "all possible part combinations" do
    {_, workflows} = parse_parts_and_workflows(@test_input)

    assert workflows
           |> total_accepted_combinations() == 167_409_079_868_000
  end
end
