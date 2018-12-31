defmodule Day11 do
  @grid_size 300

  @type coords :: {number(), number()}

  def part_one(serial_number) do
    power_level_by_coords =
      for x <- 1..@grid_size, y <- 1..@grid_size, into: %{} do
        {{x, y}, power_level({x, y}, serial_number)}
      end

    square_power_levels =
      for x <- 1..(@grid_size - 3), y <- 1..(@grid_size - 3) do
        {{x, y}, square_power_level({x, y}, power_level_by_coords)}
      end

    {square_top_left_coords, _total_power_level} =
      Enum.max_by(square_power_levels, fn {_coords, power_level} -> power_level end)

    square_top_left_coords
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

  @spec square_power_level(coords(), map()) :: number()
  def square_power_level({x, y}, power_level_by_coords) do
    for cell_x <- x..(x + 2), cell_y <- y..(y + 2) do
      power_level_by_coords[{cell_x, cell_y}]
    end
    |> Enum.sum()
  end
end
