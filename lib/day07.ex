defmodule Day07 do
  use Aoc2018

  @spec part_one(binary()) :: binary()
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

  @spec part_two(binary()) :: non_neg_integer()
  def part_two(input) do
    input
    |> parse_input()
    |> calculate_required_time(5, 60)
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

  @type difficulty :: non_neg_integer()
  @type workload :: :idle | {any(), difficulty()}

  @spec calculate_required_time(Graph.t(), non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  def calculate_required_time(graph, workers, time_step) do
    calculate_required_time(0, List.duplicate(:idle, workers), graph, time_step)
  end

  @spec calculate_required_time(non_neg_integer(), [workload], Graph.t(), non_neg_integer()) :: non_neg_integer()
  defp calculate_required_time(seconds, workloads, graph, time_step) do
    workloads = assign_work(workloads, graph, time_step)
    # |> IO.inspect(label: "workloads")

    {time, workloads, graph} = perform_work(workloads, graph)
    # IO.inspect({time, workloads}, label: "after perform")

    if Graph.empty?(graph) do
      seconds + time
    else
      calculate_required_time(seconds + time, workloads, graph, time_step)
    end
  end

  @spec assign_work([workload], Graph.t(), non_neg_integer()) :: [workload]
  defp assign_work(workloads, graph, time_step) when is_list(workloads) do
    idle_workers = Enum.count(workloads, fn e -> e == :idle end)

    already_processing =
      workloads
      |> Enum.map(fn
        :idle -> nil
        {work, _} -> work
      end)
      |> Enum.reject(&is_nil/1)
      |> MapSet.new()

    available_work =
      graph
      |> Graph.vertices_with_no_incoming_edges()
      |> Enum.reject(&MapSet.member?(already_processing, &1))
      |> Enum.sort()
      |> Enum.take(idle_workers)

    {_, workloads} =
      workloads
      |> Enum.reduce({available_work, []}, fn
        :idle, {[work | rest], res} ->
          {rest, [{work, difficulty(work) + time_step} | res]}

        workload, {available_work, res} ->
          {available_work, [workload | res]}
      end)

    workloads
  end

  @spec perform_work([workload], Graph.t()) :: {non_neg_integer(), [workload], Graph.t()}
  defp perform_work(workloads, graph) when is_list(workloads) do
    {_, smallest_difficulty} =
      workloads
      |> Enum.reject(fn w -> w == :idle end)
      |> Enum.min_by(fn {_work, difficulty} -> difficulty end)

    {workloads, graph} =
      workloads
      |> Enum.reduce({[], graph}, fn
        :idle, {workloads, graph} ->
          {[:idle | workloads], graph}

        {work, difficulty}, {workloads, graph} ->
          case difficulty - smallest_difficulty do
            0 ->
              {[:idle | workloads], Graph.remove_vertex_dirty(graph, work)}

            remaining_difficulty ->
              {[{work, remaining_difficulty} | workloads], graph}
          end
      end)

    {smallest_difficulty, workloads, graph}
  end

  @spec difficulty(binary()) :: non_neg_integer()
  defp difficulty(task) do
    <<ch::utf8>> = task
    ch - ?A + 1
  end
end
