defmodule Day18 do
  use Aoc2018

  @type object :: :empty | :lumberyard | :trees

  @spec part_one(binary()) :: non_neg_integer()
  def part_one(input) do
    input
    |> parse_map()
    |> resource_value_after_n_years(10)
  end

  @spec part_two(binary()) :: non_neg_integer()
  def part_two(input) do
    input
    |> parse_map()
    |> resource_value_after_n_years(1_000_000_000)
  end

  @spec resource_value_after_n_years(map(), non_neg_integer()) :: non_neg_integer()
  def resource_value_after_n_years(objects_map, years) do
    objects_map
    |> advance(years)
    |> resource_value()
  end

  def resource_value(objects_map) do
    tree_areas_count = objects_map |> Enum.count(fn {_, v} -> v == :trees end)
    lumberyards_count = objects_map |> Enum.count(fn {_, v} -> v == :lumberyard end)

    tree_areas_count * lumberyards_count
  end

  @doc """
  Transforms a string with encoded area map to a dict `{x_coordinate, y_coordinate} => object}`.
  """
  @spec parse_map(binary()) :: map()
  def parse_map(map_string) do
    {map, _} =
      map_string
      |> String.codepoints()
      |> Enum.reduce({%{}, {0, 0}}, fn
        "\n", {map, {_x, y}} ->
          {map, {0, y + 1}}

        symbol, {map, {x, y} = coords} ->
          new_map = Map.put(map, coords, symbol_to_object(symbol))
          new_coords = {x + 1, y}
          {new_map, new_coords}
      end)

    map
  end

  @spec advance(map(), non_neg_integer()) :: map()
  def advance(objects_map, 0) when is_map(objects_map), do: objects_map

  def advance(objects_map, steps) when is_map(objects_map) and is_integer(steps) do
    if steps < 0, do: raise("negative steps are not allowed in Day12.advance/2")

    new_map = advance(objects_map)
    hashes = %{hash(new_map) => steps - 1, hash(objects_map) => steps}
    advance(hashes, objects_map, new_map, steps - 1)
  end

  defp advance(_hashes_to_steps, _previous_map, current_map, 0) when is_map(current_map), do: current_map

  defp advance(hashes_to_steps, previous_map, current_map, steps)
       when is_map(previous_map) and is_map(current_map) and is_integer(steps) do
    new_map = advance(current_map)
    new_map_hash = hash(new_map)
    new_steps = steps - 1

    # if cycle is detected, skip repetitions of this cycle
    # and advance from the cyclic map by a number of remaining steps after repetitions skip
    if Map.has_key?(hashes_to_steps, new_map_hash) do
      cycle_length = hashes_to_steps[new_map_hash] - new_steps
      # IO.inspect(cycle_length, label: "cycle_length")
      new_steps = rem(new_steps, cycle_length)
      # IO.inspect(cycle_length, label: "new_steps")

      advance(%{}, current_map, new_map, new_steps)
    else
      hashes_to_steps = Map.put(hashes_to_steps, new_map_hash, new_steps)
      advance(hashes_to_steps, current_map, new_map, new_steps)
    end
  end

  @spec advance(map()) :: map()
  def advance(objects_map) when is_map(objects_map) do
    objects_map
    |> Enum.map(fn {coords, object} ->
      neighbours = get_neighbours(coords, objects_map)

      case object do
        :empty ->
          if empty_should_become_trees?(neighbours) do
            {coords, :trees}
          else
            {coords, :empty}
          end

        :trees ->
          if trees_should_become_lumberyard?(neighbours) do
            {coords, :lumberyard}
          else
            {coords, :trees}
          end

        :lumberyard ->
          if lumberyard_can_stay_lumberyard?(neighbours) do
            {coords, :lumberyard}
          else
            {coords, :empty}
          end
      end
    end)
    |> Enum.into(%{})
  end

  defp empty_should_become_trees?(neighbours) when is_list(neighbours) do
    Enum.count(neighbours, &(&1 == :trees)) >= 3
  end

  defp trees_should_become_lumberyard?(neighbours) when is_list(neighbours) do
    Enum.count(neighbours, &(&1 == :lumberyard)) >= 3
  end

  defp lumberyard_can_stay_lumberyard?(neighbours) when is_list(neighbours) do
    Enum.any?(neighbours, &(&1 == :lumberyard)) && Enum.any?(neighbours, &(&1 == :trees))
  end

  defp acceptible_coords?({x, y}) when is_integer(x) and is_integer(y) do
    x >= 0 && y >= 0
  end

  @neighbour_deltas [
    {-1, -1},
    {0, -1},
    {1, -1},
    {-1, 0},
    {1, 0},
    {-1, 1},
    {0, 1},
    {1, 1}
  ]

  defp get_neighbours({x, y}, objects_map) when is_map(objects_map) do
    @neighbour_deltas
    |> Enum.map(fn {delta_x, delta_y} -> {x + delta_x, y + delta_y} end)
    |> Enum.filter(&acceptible_coords?/1)
    |> Enum.map(&Map.get(objects_map, &1))
    |> Enum.reject(&is_nil/1)
  end

  defp hash(map) when is_map(map) do
    map
    |> :erlang.term_to_binary()
    |> :erlang.md5()
  end

  @spec symbol_to_object(<<_::8>>) :: object()
  defp symbol_to_object("."), do: :empty
  defp symbol_to_object("|"), do: :trees
  defp symbol_to_object("#"), do: :lumberyard
end
