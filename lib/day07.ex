defmodule Day07 do
  use Aoc2018

  def part_one(input) do
    input
    |> parse_input()
    |> Graph.topological_sort(fn vertices_without_deps ->
      vertices_without_deps
      |> Enum.sort()
      |> hd()
    end)
    |> Enum.join()
  end

  @instruction_regex ~r/^Step (?<required_step>\w) must be finished before step (?<dependent_step>\w) can begin.\s*$\s*/

  @spec parse_input(binary()) :: Graph.t()
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      captures = Regex.named_captures(@instruction_regex, line)
      {captures["required_step"], captures["dependent_step"]}
    end)
    |> Enum.reduce(Graph.new(), fn {required, dependent}, graph ->
      Graph.add_vertex(graph, dependent, edge_from: required)
    end)
  end
end
