defmodule Day20 do
  use Aoc2018

  @type direction :: :n | :e | :w | :s
  @type branch :: [direction]
  @type path :: [direction | branch]
  @type vertex :: {integer(), integer()}

  @spec part_one(binary()) :: integer()
  def part_one(input) do
    input
    |> String.trim()
    |> parse()
    |> longest_path()
  end

  def part_two(input) do
    input
    |> String.trim()
    |> parse()
    |> path_to_graph({0, 0})

    # graph.adjacency_map |> Enum.filter(fn {k, v} -> v |> Enum.uniq() |> length() > 2 end)
  end

  @spec path_to_graph(path, vertex) :: Graph.t()
  def path_to_graph(path, starting_vertex) do
    {graph, _} =
      Enum.reduce(path, {Graph.new(), starting_vertex}, fn
        path, {graph, previous_vertex} ->
          case path do
            direction when is_atom(direction) ->
              new_vertex = move(previous_vertex, direction)
              graph = Graph.add_vertex(graph, new_vertex, edge_from: previous_vertex, from_edge_label: direction)
              {graph, new_vertex}

            branches when is_list(branches) ->
              graph =
                [graph | Enum.map(branches, &path_to_graph(&1, previous_vertex))]
                |> Graph.merge()

              {graph, previous_vertex}
          end
      end)

    graph
  end

  @spec move(vertex, direction) :: vertex
  def move({x, y}, :n), do: {x, y - 1}
  def move({x, y}, :s), do: {x, y + 1}
  def move({x, y}, :e), do: {x + 1, y}
  def move({x, y}, :w), do: {x - 1, y}

  @spec longest_path(path) :: integer()
  def longest_path(path) when is_list(path) do
    longest_path(0, path)
  end

  @spec longest_path(integer(), path) :: integer()
  defp longest_path(acc, path) do
    case path do
      [x | rest] when is_atom(x) ->
        longest_path(acc + 1, rest)

      [branches | rest] when is_list(branches) ->
        # we don't need to walk loops - they can be safely skipped
        if [] in branches do
          longest_path(acc, rest)
        else
          longest_branch =
            branches
            |> Enum.map(&longest_path(0, &1))
            |> Enum.max()

          longest_path(acc + longest_branch, rest)
        end

      [] ->
        acc
    end
  end

  @spec parse(binary()) :: path | {binary(), [path]}
  def parse(input) when is_binary(input) do
    size = byte_size(input) - 2
    <<"^", path::binary-size(size), "$">> = input
    parse_path([], {[], []}, path)
  end

  @spec parse_path(list(), {list(), [path]}, binary()) :: path | {binary(), [path]}
  defp parse_path(stack, {acc, branches}, string)
       when is_list(stack) and is_list(acc) and is_list(branches) and is_binary(string) do
    case string do
      <<>> ->
        if stack != [] || branches != [] do
          raise """
          Reached end of input, but there's still some remaining stuff:
            stack = #{inspect(stack)}
            branches = #{inspect(branches)}.
          """
        end

        Enum.reverse(acc)

      <<?N::utf8, rest::binary>> ->
        parse_path(stack, {[:n | acc], branches}, rest)

      <<?E::utf8, rest::binary>> ->
        parse_path(stack, {[:e | acc], branches}, rest)

      <<?W::utf8, rest::binary>> ->
        parse_path(stack, {[:w | acc], branches}, rest)

      <<?S::utf8, rest::binary>> ->
        parse_path(stack, {[:s | acc], branches}, rest)

      <<?(::utf8, rest::binary>> ->
        parse_path([{acc, branches} | stack], {[], []}, rest)

      <<?)::utf8, rest::binary>> ->
        branches = [Enum.reverse(acc) | branches] |> Enum.reverse()
        [{prev_acc, prev_branches} | stack] = stack
        parse_path(stack, {[branches | prev_acc], prev_branches}, rest)

      <<?|::utf8, rest::binary>> ->
        parse_path(stack, {[], [Enum.reverse(acc) | branches]}, rest)
    end
  end
end
