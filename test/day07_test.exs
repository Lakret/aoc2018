defmodule Day07Test do
  use ExUnit.Case

  test "part_one is correct" do
    input = Day07.read_input()
    assert Day07.part_one(input) == "CFMNLOAHRKPTWBJSYZVGUQXIDE"
  end
end
