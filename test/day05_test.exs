defmodule Day05Test do
  use ExUnit.Case

  test "check part_one/1 with the test example" do
    assert Day05.part_one("dabAcCaCBAcCcaDA") == 10
  end

  test "check part_two/1 with the test example" do
    assert Day05.part_two("dabAcCaCBAcCcaDA") == {"c", 4}
  end

  test "correct result on the first part" do
    input = Day05.read_input()

    assert Day05.part_one(input) == 9172
  end

  @tag :heavy
  test "correct result on the second part" do
    input = Day05.read_input()

    assert Day05.part_two(input) == {"x", 6550}
  end
end
