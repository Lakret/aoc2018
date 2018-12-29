defmodule GraphTest do
  use ExUnit.Case

  test "Graph.topological_sort/2 works" do
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

    topological_sort_result =
      Graph.topological_sort(graph, fn no_deps_vertices ->
        no_deps_vertices |> Enum.sort() |> hd()
      end)

    assert topological_sort_result == ["C", "A", "B", "D", "F", "E"]
  end
end
