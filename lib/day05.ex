defmodule Day05 do
  use Aoc2018

  @spec part_one(binary()) :: non_neg_integer()
  def part_one(input) do
    input
    |> String.codepoints()
    |> reduce()
    |> length()
  end

  @spec reduce(list()) :: list()
  def reduce(codepoints) do
    {did_reduce, result} = reduction_pass(codepoints)

    # IO.inspect(result |> Enum.join(), label: "result: ")
    # IO.inspect(did_reduce, label: "did reduce?")

    if did_reduce, do: reduce(result), else: result
  end

  def reduction_pass(codepoints) do
    # TODO: fix incorrect behaviour on 2 element lists
    # probably need to add another symbold before prev?
    # try to model possible state better

    acc =
      case codepoints do
        [prev, next] -> {prev, false, [next]}
        _ -> {nil, false, [List.first(codepoints)]}
      end

    Enum.reduce(codepoints, acc, fn
      current, {nil, did_reduce, result} ->
        {current, did_reduce, result}

      current, {prev, did_reduce, result} ->
        if is_reducible?(prev, current) do
          [new_prev | new_result] = result
          {new_prev, true, new_result}
        else
          {current, did_reduce, [current | result]}
        end
    end)
    |> (fn {_, did_reduce, result} -> {did_reduce, Enum.reverse(result)} end).()
  end

  @spec is_reducible?(binary(), binary()) :: boolean()
  defp is_reducible?(element1, element2) do
    element1 != element2 && String.downcase(element1) == String.downcase(element2)
  end
end
