defmodule Day07Test do
  use ExUnit.Case

  test "part_one is correct" do
    input = Day07.read_input()
    assert Day07.part_one(input) == "CFMNLOAHRKPTWBJSYZVGUQXIDE"
  end

  test "part_two is correct" do
    input = Day07.read_input()
    assert Day07.part_two(input) == 971
  end

  test "part_two is correct for simple case" do
    deps = [
      {"C", "A"},
      {"C", "F"},
      {"A", "B"},
      {"A", "D"},
      {"B", "E"},
      {"D", "E"},
      {"F", "E"}
    ]

    graph =
      Enum.reduce(deps, Graph.new(), fn {from, to}, graph ->
        Graph.add_vertex(graph, to, edge_from: from)
      end)

    assert Day07.calculate_required_time(graph, 2, 0) == 15
  end
end
