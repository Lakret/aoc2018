defmodule Day05 do
  use Aoc2018

  @spec part_one(binary()) :: non_neg_integer()
  def part_one(input) do
    input
    |> String.codepoints()
    |> Enum.reject(&(&1 == "\n"))
    |> reduce()
    |> length()
  end

  @spec part_two(binary()) :: {binary(), non_neg_integer()}
  def part_two(input) do
    units = input |> String.codepoints() |> Enum.reject(&(&1 == "\n"))
    unique_units = input |> String.downcase() |> String.codepoints() |> Enum.uniq()

    unique_units
    |> Enum.map(fn unit_to_remove ->
      result =
        units
        |> remove_unit_irrespective_of_case(unit_to_remove)
        |> reduce()
        |> length()

      {unit_to_remove, result}
    end)
    |> Enum.min_by(fn {_unit_to_remove, result} -> result end)
  end

  def remove_unit_irrespective_of_case(units, unit_to_remove) do
    Enum.reject(units, fn unit -> String.downcase(unit) == unit_to_remove end)
  end

  @spec reduce(list()) :: list()
  def reduce(codepoints) do
    {did_reduce, result} = reduction_pass(codepoints)

    if did_reduce, do: reduce(result), else: result
  end

  def reduction_pass(codepoints) do
    Enum.reduce(codepoints, {false, []}, fn
      current, {did_reduce, []} ->
        {did_reduce, [current]}

      current, {did_reduce, [prev | without_prev_result] = result} ->
        if is_reducible?(prev, current) do
          {true, without_prev_result}
        else
          {did_reduce, [current | result]}
        end
    end)
    |> (fn {did_reduce, result} -> {did_reduce, Enum.reverse(result)} end).()
  end

  @spec is_reducible?(binary(), binary()) :: boolean()
  defp is_reducible?(element1, element2) do
    element1 != element2 && String.downcase(element1) == String.downcase(element2)
  end
end
