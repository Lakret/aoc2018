defmodule Day20Test do
  use ExUnit.Case

  test "simple parsing is correct" do
    input = "^EN(NWE)$"
    expected = [:e, :n, [[:n, :w, :e]]]

    assert Day20.parse(input) == expected

    input = "^EN(NWE|SN)$"
    expected = [:e, :n, [[:n, :w, :e], [:s, :n]]]

    assert Day20.parse(input) == expected

    input = "^EN(NWE|SN|)$"
    expected = [:e, :n, [[:n, :w, :e], [:s, :n], []]]

    assert Day20.parse(input) == expected
  end

  test "parsing is correct" do
    input = "^ENWWW(NEEE|SSE(EE|N))$"
    expected = [:e, :n, :w, :w, :w, [[:n, :e, :e, :e], [:s, :s, :e, [[:e, :e], [:n]]]]]

    assert Day20.parse(input) == expected
  end

  test "part_one is correct for simple examples" do
    assert Day20.part_one("^WNE$") == 3
    assert Day20.part_one("^ENWWW(NEEE|SSE(EE|N))$") == 10
    assert Day20.part_one("^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$") == 18
  end
end
