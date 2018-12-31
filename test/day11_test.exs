defmodule Day11Test do
  use ExUnit.Case

  test "Day11.power_level/2 is correct" do
    assert Day11.power_level({3, 5}, 8) == 4
    assert Day11.power_level({122, 79}, 57) == -5
    assert Day11.power_level({217, 196}, 39) == 0
    assert Day11.power_level({101, 153}, 71) == 4
  end

  # using example from https://en.wikipedia.org/wiki/Summed-area_table
  @magical_square %{
    {1, 1} => 31,
    {2, 1} => 2,
    {3, 1} => 4,
    {1, 2} => 12,
    {2, 2} => 26,
    {3, 2} => 9,
    {1, 3} => 13,
    {2, 3} => 17,
    {3, 3} => 21
  }

  test "Day11.summed_area_table/1 is correct" do
    expected_sum_table = %{
      {1, 1} => 31,
      {2, 1} => 33,
      {3, 1} => 37,
      {1, 2} => 43,
      {2, 2} => 71,
      {3, 2} => 84,
      {1, 3} => 56,
      {2, 3} => 101,
      {3, 3} => 135
    }

    assert Day11.compute_summed_area_table(@magical_square, 3) == expected_sum_table
  end

  test "Day11.calculate_sum_in_square/3 is correct" do
    summed_area_table = Day11.compute_summed_area_table(@magical_square, 3)
    assert Day11.calculate_sum_in_square(summed_area_table, {1, 1}, 2) == 71
  end

  @tag :heavy
  test "part_one is correct" do
    assert Day11.part_one(18) == {33, 45}
    assert Day11.part_one(42) == {21, 61}
    assert Day11.part_one(3628) == {216, 12}
  end

  @tag :heavy
  test "part_two is correct" do
    assert Day11.part_two(18) == {{90, 269}, 16}
    assert Day11.part_two(42) == {{232, 251}, 12}
    assert Day11.part_two(3628) == {{236, 175}, 11}
  end
end
