defmodule Graph do
  @moduledoc """
  Graph has a following representation: it's a struct with a key `adjacency_map`.
  `adjacency_map` is a map from vertex (any term) to a list of tuples `{adjacent_vertex, %Graph.Edge{...}}`.
  """

  @enforce_keys [:adjacency_map]
  defstruct [:adjacency_map]

  @type t :: %__MODULE__{}
  @type adjacency_list :: [{any(), %Graph.Edge{}}]

  defmodule Edge do
    defstruct [:label]
  end

  @spec new() :: Graph.t()
  def new() do
    %__MODULE__{adjacency_map: %{}}
  end

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
end
