defmodule Day01 do
  use Aoc2018

  @doc ~S"""
  Calculates final frequency by parsing all the adjustments and adding them up.

  ## Examples

      iex> Day01.part_one("+12\n-5\n3")
      10

  """
  @spec part_one(binary()) :: number()
  def part_one(input) do
    convert_to_frequency_adjustment_list(input)
    |> Enum.sum()
  end

  defp convert_to_frequency_adjustment_list(input) do
    input
    |> String.split("\n")
    |> Enum.map(&strip_plus_sign/1)
    |> Enum.map(&String.to_integer/1)
  end

  defp strip_plus_sign("+" <> rest), do: rest
  defp strip_plus_sign(x), do: x

  @doc ~S"""
  Cycles through adjustment list until a first frequency that was reached twice is found. Returns this frequency.

  ## Examples

      iex> Day01.part_two("+1\n-1")
      0
      iex> Day01.part_two("+3\n+3\n+4\n-2\n-4")
      10
      iex> Day01.part_two("-6\n+3\n+8\n+5\n-6")
      5
      iex> Day01.part_two("+7\n+7\n-2\n-7\n-4")
      14

  """
  def part_two(input) do
    convert_to_frequency_adjustment_list(input)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn adjustment, {current_frequency, encountered} ->
      current_frequency = current_frequency + adjustment

      if current_frequency in encountered do
        {:halt, current_frequency}
      else
        encountered = MapSet.put(encountered, current_frequency)
        {:cont, {current_frequency, encountered}}
      end
    end)
  end
end
