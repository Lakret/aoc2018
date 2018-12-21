defmodule Day04 do
  use Aoc2018

  @spec part_one([binary()]) :: number()
  def part_one(input) do
    sleep_map = parse_and_get_sleep_map(input)

    {sleepiest_guard_id, sleep_minutes} =
      sleep_map
      |> Enum.max_by(fn {_guard_id, sleep_minutes} -> length(sleep_minutes) end)

    {the_most_slept_minute, _} =
      sleep_minutes
      |> Enum.group_by(& &1)
      |> Enum.max_by(fn {_minute, occurrences} -> length(occurrences) end)

    sleepiest_guard_id * the_most_slept_minute
  end

  @spec part_two([binary()]) :: number()
  def part_two(input) do
    sleep_map = parse_and_get_sleep_map(input)

    minute_to_guard_ids_to_counts_map =
      sleep_map
      |> Enum.reduce(%{}, fn {guard_id, sleep_minutes}, acc ->
        Enum.reduce(sleep_minutes, acc, fn sleep_minute, acc ->
          Map.update(acc, sleep_minute, %{guard_id => 1}, fn guard_id_to_count_on_this_minute ->
            guard_id_to_count_on_this_minute
            |> Map.update(guard_id, 1, &(&1 + 1))
          end)
        end)
      end)

    {most_frequent_minute, guard_ids_to_counts} =
      minute_to_guard_ids_to_counts_map
      |> Enum.max_by(fn {_minute, guard_ids_to_counts} ->
        {_guard_id, count} = Enum.max_by(guard_ids_to_counts, fn {_, count} -> count end)
        count
      end)

    {guard_id, _} = Enum.max_by(guard_ids_to_counts, fn {_, count} -> count end)

    most_frequent_minute * guard_id
  end

  defp parse_and_get_sleep_map(input) do
    input
    |> GuardLog.parse_log()
    |> GuardLog.to_guard_sleep_map()
  end
end
