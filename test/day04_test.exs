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
    %Day04.GuardLog{datetime: ~N[1518-11-01 00:00:00], event: :shift_begins, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-01 00:05:00], event: :falls_asleep, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-01 00:25:00], event: :wakes_up, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-01 00:30:00], event: :falls_asleep, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-01 00:55:00], event: :wakes_up, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-01 23:58:00], event: :shift_begins, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-02 00:40:00], event: :falls_asleep, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-02 00:50:00], event: :wakes_up, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-03 00:05:00], event: :shift_begins, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-03 00:24:00], event: :falls_asleep, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-03 00:29:00], event: :wakes_up, guard_id: 10},
    %Day04.GuardLog{datetime: ~N[1518-11-04 00:02:00], event: :shift_begins, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-04 00:36:00], event: :falls_asleep, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-04 00:46:00], event: :wakes_up, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-05 00:03:00], event: :shift_begins, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-05 00:45:00], event: :falls_asleep, guard_id: 99},
    %Day04.GuardLog{datetime: ~N[1518-11-05 00:55:00], event: :wakes_up, guard_id: 99}
  ]

  test "log parsers is correct" do
    assert Day04.GuardLog.parse_log(@log) == @parsed_log
  end
end
