defmodule Day04 do
  use Aoc2018

  alias Timex
  alias Timex.Duration

  defmodule GuardLog do
    @enforce_keys [:datetime, :guard_id, :event]
    defstruct [:datetime, :event, :guard_id]

    @type log_line :: %GuardLog{datetime: NaiveDateTime.t(), event: atom(), guard_id: integer()}
    @type t :: [log_line]

    @type parsed_line ::
            {:falls_asleep, NaiveDateTime.t()}
            | {:wakes_up, NaiveDateTime.t()}
            | {:shift_begins, NaiveDateTime.t(), any()}

    @spec parse_log([binary]) :: t
    def parse_log(lines) when is_list(lines) do
      {_, log} =
        lines
        |> Enum.map(&parse_log_line/1)
        |> Enum.sort_by(fn
          {_event, datetime} -> datetime |> Timex.to_unix()
          {_event, datetime, _guard_id} -> datetime |> Timex.to_unix()
        end)
        |> Enum.reduce({nil, []}, fn
          {:shift_begins = event, datetime, new_guard_id}, {_old_guard_id, parsed} ->
            item = %GuardLog{datetime: datetime, guard_id: new_guard_id, event: event}
            {new_guard_id, [item | parsed]}

          {event, datetime}, {guard_id, parsed} ->
            item = %GuardLog{datetime: datetime, guard_id: guard_id, event: event}
            {guard_id, [item | parsed]}
        end)

      log |> Enum.reverse()
    end

    @doc """
    Converts `GuardLog` list into a map from `guard_id` to a list of all minutes he slept.
    Minutes are represented as simple integers.
    """
    @spec to_guard_sleep_map(t) :: map()
    def to_guard_sleep_map(log) when is_list(log) do
      log
      |> Enum.reduce(%{}, fn elem, acc ->
        %GuardLog{datetime: datetime, event: event, guard_id: guard_id} = elem

        case event do
          :falls_asleep ->
            Map.put(acc, :started_sleep, datetime)

          :wakes_up ->
            sleep_minutes = get_sleep_minutes(acc.started_sleep, datetime)

            acc
            |> Map.update(guard_id, sleep_minutes, fn all_sleep_minutes -> all_sleep_minutes ++ sleep_minutes end)
            |> Map.delete(:started_sleep)

          :shift_begins ->
            acc
        end
      end)
    end

    @one_minute Duration.from_minutes(1)

    @spec get_sleep_minutes(Time.t(), Time.t()) :: [integer()]
    defp get_sleep_minutes(start_dt, end_dt) do
      end_dt_discounting_last_minute = Timex.subtract(end_dt, @one_minute)

      Stream.unfold({:init, start_dt}, fn
        # don't forget to add initial value to output
        {:init, current} ->
          {current, current}

        current ->
          if Timex.equal?(current, end_dt_discounting_last_minute, :minutes) do
            nil
          else
            new_dt = Timex.add(current, @one_minute)
            {new_dt, new_dt}
          end
      end)
      |> Enum.map(fn %NaiveDateTime{minute: minute} -> minute end)
    end

    @spec parse_log_line(binary()) :: parsed_line()
    defp parse_log_line(line) when is_binary(line) do
      splitted = [date, time | _] = String.split(line, [" ", "[", "]", "#"], trim: true)
      datetime = date_and_time_to_datetime(date, time)

      case splitted |> Enum.drop(2) do
        ["Guard", guard_id, "begins", "shift"] ->
          {:shift_begins, datetime, String.to_integer(guard_id)}

        ["falls", "asleep"] ->
          {:falls_asleep, datetime}

        ["wakes", "up"] ->
          {:wakes_up, datetime}
      end
    end

    @spec date_and_time_to_datetime(binary(), binary()) :: NaiveDateTime.t()
    defp date_and_time_to_datetime(date, time) when is_binary(date) and is_binary(time) do
      {:ok, dt} = NaiveDateTime.from_iso8601("#{date}T#{time}:00Z")
      dt
    end
  end

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

  def part_two(input) do
    sleep_map = parse_and_get_sleep_map(input)

    minute_to_guard_ids_to_counts_map =
      sleep_map
      |> Enum.reduce(%{}, fn {guard_id, sleep_minutes}, acc ->
        Enum.reduce(sleep_minutes, acc, fn sleep_minute, acc ->
          Map.update(acc, sleep_minute, %{guard_id: 1}, fn guard_id_to_count_on_this_minute ->
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
