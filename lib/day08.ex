defmodule Day08 do
  use Aoc2018

  def part_one(input) do
    input
    |> parse_input()
    |> sum_metadata()
  end

  def part_two(input) do
    input
    |> parse_input()
    |> get_node_value()
  end

  def parse_input(input) do
    {tree, _unparsed = []} =
      input
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> parse_node()

    tree
  end

  defp parse_node([children_count, metadata_count | rest]) do
    {children, rest} = parse_children(rest, children_count)
    {metadata, rest} = Enum.split(rest, metadata_count)
    {%{metadata: metadata, children: children}, rest}
  end

  defp parse_children(input, children_count) do
    {children, rest} =
      List.duplicate(nil, children_count)
      |> Enum.reduce({[], input}, fn _, {children, input} ->
        {child, rest} = parse_node(input)
        {[child | children], rest}
      end)

    {Enum.reverse(children), rest}
  end

  defp sum_metadata(%{children: children, metadata: metadata}) do
    children_metadata_sum = children |> Enum.map(&sum_metadata/1) |> Enum.sum()
    Enum.sum(metadata) + children_metadata_sum
  end

  defp get_node_value(%{children: [], metadata: metadata}), do: Enum.sum(metadata)

  defp get_node_value(%{children: children, metadata: metadata}) do
    metadata
    |> Enum.map(&child_value(children, &1))
    |> Enum.sum()
  end

  defp child_value(_children, 0), do: 0
  defp child_value(children, x) when x > length(children), do: 0

  defp child_value(children, idx) do
    children
    |> Enum.at(idx - 1)
    |> get_node_value()
  end
end
