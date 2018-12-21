defmodule Day04Test do
  use ExUnit.Case

  @log [
    "[1518-11-01 00:00] Guard #10 begins shift",
    "[1518-11-01 00:05] falls asleep",
    "[1518-11-01 00:25] wakes up",
    "[1518-11-01 00:30] falls asleep",
    "[1518-11-01 00:55] wakes up",
    "[1518-11-01 23:58] Guard #99 begins shift",
    "[1518-11-02 00:40] falls asleep",
    "[1518-11-02 00:50] wakes up",
    "[1518-11-03 00:05] Guard #10 begins shift",
    "[1518-11-03 00:24] falls asleep",
    "[1518-11-03 00:29] wakes up",
    "[1518-11-04 00:02] Guard #99 begins shift",
    "[1518-11-04 00:36] falls asleep",
    "[1518-11-04 00:46] wakes up",
    "[1518-11-05 00:03] Guard #99 begins shift",
    "[1518-11-05 00:45] falls asleep",
    "[1518-11-05 00:55] wakes up"
  ]

  @parsed_log [
    %GuardLog{datetime: ~N[1518-11-01 00:00:00], event: :shift_begins, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-01 00:05:00], event: :falls_asleep, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-01 00:25:00], event: :wakes_up, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-01 00:30:00], event: :falls_asleep, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-01 00:55:00], event: :wakes_up, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-01 23:58:00], event: :shift_begins, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-02 00:40:00], event: :falls_asleep, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-02 00:50:00], event: :wakes_up, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-03 00:05:00], event: :shift_begins, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-03 00:24:00], event: :falls_asleep, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-03 00:29:00], event: :wakes_up, guard_id: 10},
    %GuardLog{datetime: ~N[1518-11-04 00:02:00], event: :shift_begins, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-04 00:36:00], event: :falls_asleep, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-04 00:46:00], event: :wakes_up, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-05 00:03:00], event: :shift_begins, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-05 00:45:00], event: :falls_asleep, guard_id: 99},
    %GuardLog{datetime: ~N[1518-11-05 00:55:00], event: :wakes_up, guard_id: 99}
  ]

  @sleep_minutes_map %{
    10 =>
      [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24] ++
        [30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50] ++
        [51, 52, 53, 54, 24, 25, 26, 27, 28],
    99 =>
      [40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 45] ++
        [46, 47, 48, 49, 50, 51, 52, 53, 54]
  }

  test "log parsers is correct" do
    assert GuardLog.parse_log(@log) == @parsed_log
  end

  test "log is convertible to a sleep minutes map" do
    assert GuardLog.to_guard_sleep_map(@parsed_log) == @sleep_minutes_map
  end

  test "strategy one works" do
    assert Day04.part_one(@log) == 240
  end

  test "strategy two works" do
    assert Day04.part_two(@log) == 4455
  end

  test "correct result on the first part" do
    input = Day04.read_input() |> String.split("\n", trim: true)

    assert Day04.part_one(input) == 106_710
  end

  test "correct result on the second part" do
    input = Day04.read_input() |> String.split("\n", trim: true)

    assert Day04.part_two(input) == 10491
  end
end
