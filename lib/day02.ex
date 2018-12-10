defmodule Day02 do
  use Aoc2018

  @doc ~S"""
  Counts checksum as [specified](https://adventofcode.com/2018/day/2).

  ## Example

      iex> Day02.part_one(~s(abcdef\nbababc\nabbcde\nabcccd\naabcdd\nabcdee\nababab))
      12

  """
  @spec part_one(binary()) :: number()
  def part_one(input) when is_binary(input) do
    {twice_count, thrice_count} =
      input
      |> String.split()
      |> Enum.reduce({0, 0}, fn id, {twice_count, thrice_count} ->
        counts = get_letter_counts(id)

        twice_count = if contains_repeated_twice_letter?(counts), do: twice_count + 1, else: twice_count
        thrice_count = if contains_repeated_thrice_letter?(counts), do: thrice_count + 1, else: thrice_count

        {twice_count, thrice_count}
      end)

    twice_count * thrice_count
  end

  defp get_letter_counts(str) when is_binary(str) do
    str
    |> String.codepoints()
    |> Enum.reduce(%{}, fn letter, counts ->
      Map.update(counts, letter, 1, &(&1 + 1))
    end)
  end

  defp contains_repeated_twice_letter?(counts), do: 2 in Map.values(counts)
  defp contains_repeated_thrice_letter?(counts), do: 3 in Map.values(counts)

  @doc ~S"""
  Finds two ids differing only by one letter at the same position. Returns letters that are matching.

  ## Example

      iex> Day02.part_two("abcde\nfghij\nklmno\npqrst\nfguij\naxcye\nwvxyz")
      "fgij"

  """
  @spec part_two(binary()) :: binary() | nil
  def part_two(input) when is_binary(input) do
    input
    |> String.split()
    |> solve()
  end

  defp solve([first_id | remaining_ids]) when remaining_ids != [] do
    answer =
      remaining_ids
      |> Enum.find_value(&find_matching_letters_if_different_by_one_letter_only(first_id, &1))

    if is_nil(answer), do: solve(remaining_ids), else: answer
  end

  @spec find_matching_letters_if_different_by_one_letter_only(binary(), binary()) :: binary() | nil
  defp find_matching_letters_if_different_by_one_letter_only(id1, id2) do
    chars1 = String.codepoints(id1)
    chars2 = String.codepoints(id2)

    if length(chars1) == length(chars2) do
      matching =
        Enum.zip(chars1, chars2)
        |> Enum.filter(fn {x, y} -> x == y end)
        |> Enum.map(fn {x, _} -> x end)

      if length(matching) == length(chars1) - 1, do: Enum.join(matching), else: nil
    else
      nil
    end
  end
end
