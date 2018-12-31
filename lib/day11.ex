defmodule Day11 do
  @grid_size 300

  @type coords :: {number(), number()}

  @spec part_one(number()) :: coords()
  def part_one(serial_number) do
    {square_top_left_coords, _total_power_level} =
      serial_number
      |> compute_power_level_by_coords()
      |> compute_summed_area_table(@grid_size)
      |> get_left_top_coords_and_power_level_of_max_power_level_square_for_size(3)

    square_top_left_coords
  end

  @spec part_two(any()) :: {coords(), integer()}
  def part_two(serial_number) do
    power_level_by_coords = compute_power_level_by_coords(serial_number)
    summed_area_table = compute_summed_area_table(power_level_by_coords, @grid_size)

    {size, {coords, _power_level}} =
      1..300
      |> Flow.from_enumerable()
      |> Flow.map(fn size ->
        {size, get_left_top_coords_and_power_level_of_max_power_level_square_for_size(summed_area_table, size)}
      end)
      # |> Flow.group_by(fn {size, {coords, power_level}} -> size end)
      # |> Flow.take_sort(1, fn {_size1, {_coords1, power_level1}}, {_size2, {_coords2, power_level2}} ->
      #   power_level2 < power_level1
      # end)
      # |> Enum.to_list()
      # |> hd()

      |> Enum.max_by(fn {_size, {_coords, power_level}} -> power_level end)

    {coords, size}
  end

  @spec get_left_top_coords_and_power_level_of_max_power_level_square_for_size(map(), integer()) ::
          {coords(), integer()}
  defp get_left_top_coords_and_power_level_of_max_power_level_square_for_size(summed_area_table, size) do
    calculate_power_levels_in_squares_with_size(summed_area_table, size)
    |> Enum.max_by(fn {_coords, power_level} -> power_level end)
  end

  @spec calculate_power_levels_in_squares_with_size(map(), integer()) :: [{coords(), integer()}]
  defp calculate_power_levels_in_squares_with_size(summed_area_table, size) do
    for x <- 1..(@grid_size - size), y <- 1..(@grid_size - size) do
      power_level = calculate_sum_in_square(summed_area_table, {x, y}, size)
      {{x, y}, power_level}
    end
  end

  @doc """
  See [wiki article](https://en.wikipedia.org/wiki/Summed-area_table).
  Coordinates are 1-indexed.
  """
  @spec compute_summed_area_table(map(), number()) :: map()
  def compute_summed_area_table(power_level_by_coords, grid_size) do
    coords = for x <- 1..grid_size, y <- 1..grid_size, do: {x, y}

    Enum.reduce(coords, %{}, fn {x, y}, table ->
      s =
        Map.get(table, {x, y}, power_level_by_coords[{x, y}]) + Map.get(table, {x, y - 1}, 0) +
          Map.get(table, {x - 1, y}, 0) - Map.get(table, {x - 1, y - 1}, 0)

      Map.put(table, {x, y}, s)
    end)
  end

  @spec calculate_sum_in_square(map(), coords(), number()) :: number()
  def calculate_sum_in_square(summed_area_table, {x, y} = _top_left_coords, size) when is_map(summed_area_table) do
    offset = size - 1
    get_value_by_coords = fn {x, y} -> Map.get(summed_area_table, {x, y}, 0) end

    bottom_right_value_D = get_value_by_coords.({x + offset, y + offset})
    top_left_bounding_value_A = get_value_by_coords.({x - 1, y - 1})
    top_right_bounding_value_B = get_value_by_coords.({x + offset, y - 1})
    bottom_left_bounding_value_C = get_value_by_coords.({x - 1, y + offset})

    top_left_bounding_value_A + bottom_right_value_D - top_right_bounding_value_B - bottom_left_bounding_value_C
  end

  @spec compute_power_level_by_coords(number()) :: map()
  defp compute_power_level_by_coords(serial_number) do
    for x <- 1..@grid_size, y <- 1..@grid_size, into: %{} do
      {{x, y}, power_level({x, y}, serial_number)}
    end
  end

  @spec power_level(coords(), number()) :: number()
  def power_level({x, y}, serial_number) do
    rack_id = x + 10
    power_level = (rack_id * y + serial_number) * rack_id

    hundreds_digit =
      power_level
      |> Integer.to_string()
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.at(2, "0")
      |> String.to_integer()

    hundreds_digit - 5
  end
end
