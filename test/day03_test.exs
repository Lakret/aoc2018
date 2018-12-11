defmodule Day03Test do
  use ExUnit.Case

  @claims [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2"
  ]

  test "intersection algorithm is correct" do
    assert Day03.part_one(@claims) == 4
  end

  test "algorithm for finding non-intersecting claim id is correct" do
    assert Day03.part_two(@claims) == 3
  end
end
