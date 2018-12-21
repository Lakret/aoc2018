defmodule Day18Test do
  use ExUnit.Case

  @map_string """
  |#.
  ##|
  .#.
  """

  @expected_parsed_map %{
    {0, 0} => :trees,
    {1, 0} => :lumberyard,
    {2, 0} => :empty,
    {0, 1} => :lumberyard,
    {1, 1} => :lumberyard,
    {2, 1} => :trees,
    {0, 2} => :empty,
    {1, 2} => :lumberyard,
    {2, 2} => :empty
  }

  test "check parsing function" do
    assert Day18.parse_map(@map_string) == @expected_parsed_map
  end

  test "part_one is correct" do
    input = Day18.read_input()

    assert Day18.part_one(input) == 549_936
  end

  @tag :heavy
  test "part_two is correct" do
    input = Day18.read_input()

    assert Day18.part_two(input) == 206_304
  end
end
