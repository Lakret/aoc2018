defmodule Day20 do
  use Aoc2018

  @spec part_one(binary()) :: integer()
  def part_one(input) do
    input = String.trim(input)

    longest_shortest_path(input)
  end

  @spec longest_shortest_path(binary()) :: integer()
  def longest_shortest_path(input) do
    longest_shortest_path([], input, 0)
  end

  @spec longest_shortest_path(binary(), integer()) :: integer()
  def longest_shortest_path(_callbacks, "", x), do: x

  # def longest_shortest_path(callbacks, "(" <> rest, x) do
  #   longest_shortest_path()
  # end

  # def longest_shortest_path(callbacks, "|" <> rest, x) do
  # end

  # def longest_shortest_path(callbacks, ")" <> rest, x) do
  #   longest_shortest_path()
  # end

  def longest_shortest_path(<<_::8>> <> rest, x), do: longest_shortest_path(rest, x + 1)
end
