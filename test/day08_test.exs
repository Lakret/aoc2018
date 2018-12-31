defmodule Day08Test do
  use ExUnit.Case

  test "parsing works" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

    expected = %{
      metadata: [1, 1, 2],
      children: [
        %{metadata: [10, 11, 12], children: []},
        %{
          metadata: [2],
          children: [
            %{metadata: [99], children: []}
          ]
        }
      ]
    }

    assert Day08.parse_input(input) == expected
  end

  test "part one is correct" do
    input = Day08.read_input()
    assert Day08.part_one(input) == 41555
  end

  test "part two is correct" do
    input = Day08.read_input()
    assert Day08.part_two(input) == 16653
  end
end
