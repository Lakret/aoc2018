defmodule Day04 do
  use Aoc2018

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
          {_event, datetime} -> datetime
          {_event, datetime, _guard_id} -> datetime
        end)
        |> Enum.reduce({nil, []}, fn
          {:shift_begins, datetime, new_guard_id}, {_old_guard_id, parsed} ->
            item = %GuardLog{datetime: datetime, guard_id: new_guard_id, event: :shift_begins}
            {new_guard_id, [item | parsed]}

          {event, datetime}, {guard_id, parsed} ->
            item = %GuardLog{datetime: datetime, guard_id: guard_id, event: event}
            {guard_id, [item | parsed]}
        end)

      log |> Enum.reverse()
    end

    # TODO: how to encode minutes between 2 hours?
    # %{ guard_id => [ (start_sleep_minitue, end_sleep), ... ]}
    def to_guard_sleep_map(log) do
      log
      |> Enum.reduce(%{}, fn line -> nil end)
    end

    def sleep_time_and_the_most_slept_minute_by_guard_id(log) do
      # TODO:
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

  def part_one(input) do
    # TODO:
  end
end
