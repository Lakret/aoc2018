defmodule Day20 do
  use Aoc2018

  @type direction :: :n | :e | :w | :s
  @type branch :: [direction]
  @type path :: [direction | branch]

  @spec part_one(binary()) :: integer()
  def part_one(input) do
    input = String.trim(input)

    input
    |> parse()
    |> longest_path()
  end

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
        # if loop?(branches) do
        #   longest_path(acc, rest)
        # else
        branches
        |> Enum.map(&longest_path(0, &1))
        |> Enum.max()

      # end

      [] ->
        acc
    end
  end

  defp loop?(branches) when is_list(branches) do
    Enum.any?(branches, fn x -> x == [] end)
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
