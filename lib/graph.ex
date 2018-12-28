defmodule Graph do
  @moduledoc """
  Directed graph has a following representation: it's a struct with a key `adjacency_map`.
  `adjacency_map` is a map from vertex (any term) to a list of tuples `{adjacent_vertex, %Graph.Edge{...}}`.

  Thus, this adjacency map:

  ```
  alias Graph.Edge

  %{
    a: [
      {b, %Edge{label: "a to b"}},
      {c, %Edge{label: "a to c"}}
    ],
    b: [{c, %Edge{label: "b to c"}}],
    c: [{c, %Edge{label: "c to itself"}}]
  }
  ```

  represents this graph:

  ```
  a --"a to b"--> b
  a --"a to c"--> c
  b --"b to c"--> c
  c --"c to itself"--> c
  ```
  """

  @enforce_keys [:adjacency_map]
  defstruct [:adjacency_map]

  @type t :: %__MODULE__{}
  @type adjacency_list :: [{any(), %Graph.Edge{}}]

  defmodule Edge do
    @moduledoc """
    Struct representing edges in a graph.
    """

    defstruct [:label]
  end

  @spec new() :: Graph.t()
  def new() do
    %__MODULE__{adjacency_map: %{}}
  end

  def vertices(graph) do
    graph.adjacency_map
    |> Map.keys()
  end

  @doc """
  Returns a list of vertices - neighbours of `vertex` (vertices, direclty reachable from `vertex`) in `graph`.
  """
  @spec neighbours(Graph.t(), any()) :: [any()]
  def neighbours(graph, vertex) do
    Map.get(graph.adjacency_map, vertex, [])
    |> Enum.map(fn {vertex, _edge} -> vertex end)
  end

  @doc """
  Adds `new_vertex` to graph.

  Options:
    - `edge_from` - if specified, will also create an edge from `edge_from` vertex to `new_vertex`.
    - `from_edge_label` - if specified, and `edge_from` is also specified, will label the edge from `edge_from` to `new_vertex`
    with `from_edge_label`.
    - `remove_duplicates` - boolean, `true` by default. If `true`, duplicate entries from `adjacency_list`s of vertices will be removed.
  """
  @spec add_vertex(Graph.t(), any(), keyword()) :: Graph.t()
  def add_vertex(graph, new_vertex, opts \\ []) do
    new_adjacency_map =
      graph.adjacency_map
      |> Map.put_new(new_vertex, [])

    edge_from = Keyword.get(opts, :edge_from)
    from_edge_label = Keyword.get(opts, :from_edge_label)

    new_adjacency_map =
      if edge_from do
        adjacency_item = {new_vertex, %__MODULE__.Edge{label: from_edge_label}}

        Map.update(new_adjacency_map, edge_from, [adjacency_item], fn from_vertex_existing_adjacency ->
          [adjacency_item | from_vertex_existing_adjacency]
          |> conditionally_remove_duplicates(opts)
        end)
      else
        new_adjacency_map
      end

    %__MODULE__{adjacency_map: new_adjacency_map}
  end

  @doc """
  Merges a list of `graphs` to a new graph.

  `adjacency_list`s for individual vertices will be concatenated on merge.

  Options:
    - `remove_duplicates` - boolean, `true` by default. If `true`, duplicate entries from `adjacency_list`s of vertices will be removed.
  """
  @spec merge([Graph.t()], keyword()) :: Graph.t()
  def merge(graphs, opts \\ []) when is_list(graphs) do
    graphs
    |> Enum.reduce(fn graph, merged ->
      %__MODULE__{
        adjacency_map:
          Map.merge(merged.adjacency_map, graph.adjacency_map, fn _k, v1, v2 ->
            Enum.concat(v1, v2)
            |> conditionally_remove_duplicates(opts)
          end)
      }
    end)
  end

  # if `:remove_duplicates` is truthy in `opts`, removes duplicates from `adjacency_list`.
  @spec conditionally_remove_duplicates(adjacency_list, keyword()) :: adjacency_list
  defp conditionally_remove_duplicates(adjacency_list, opts) do
    remove_duplicates = Keyword.get(opts, :remove_duplicates, true)

    if remove_duplicates, do: Enum.uniq(adjacency_list), else: adjacency_list
  end

  @doc """
  Traverses `graph` in breadth-first order, accumulating data by invoking `reducer` on each vertex.

  **Note:** this assumes that the whole `graph` has only one strongly connected component. If it's not true, this will not terminate.

  Each vertex is visited only one time.

  `reducer` takes `previous_vertex`, `current_vertex`, and `accumulator` as parameters, and returns new accumulator.

  Returns final value of acumulator, and a `MapSet` of visited vertices.
  """
  @spec traverse_breadth_first(Graph.t(), any(), any(), any()) :: {any(), [any()]}
  def traverse_breadth_first(graph, start_vertex, acc, reducer) do
    unvisited = vertices(graph) |> Enum.reject(fn v -> v == start_vertex end) |> MapSet.new()

    {acc, visited} = traverse_breadth_first(unvisited, MapSet.new([start_vertex]), graph, start_vertex, acc, reducer)

    {acc, Enum.reverse(visited)}
  end

  defp traverse_breadth_first(unvisited, visited, graph, prev_vertex, acc, reducer) do
    if Enum.empty?(unvisited) do
      {acc, visited}
    else
      neighbours = neighbours(graph, prev_vertex)

      acc = Enum.reduce(neighbours, acc, fn current_vertex, acc -> reducer.(prev_vertex, current_vertex, acc) end)

      unvisited = MapSet.difference(unvisited, MapSet.new(neighbours))

      Enum.reduce(neighbours, {acc, visited}, fn neighbour, {acc, visited} ->
        if MapSet.member?(visited, neighbour) do
          {acc, visited}
        else
          visited = MapSet.put(visited, neighbour)
          traverse_breadth_first(unvisited, visited, graph, neighbour, acc, reducer)
        end
      end)
    end
  end
end
