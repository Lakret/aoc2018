defmodule Day11Test do
  use ExUnit.Case

  test "Day11.power_level/2 is correct" do
    assert Day11.power_level({3, 5}, 8) == 4
    assert Day11.power_level({122, 79}, 57) == -5
    assert Day11.power_level({217, 196}, 39) == 0
    assert Day11.power_level({101, 153}, 71) == 4
  end

  @tag :heavy
  test "part_one is correct" do
    assert Day11.part_one(18) == {33, 45}
    assert Day11.part_one(42) == {21, 61}
    assert Day11.part_one(3628) == {216, 12}
  end
end
