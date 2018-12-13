defmodule Day05Test do
  use ExUnit.Case

  test "check part_one/1 with the test example" do
    assert Day05.part_one("dabAcCaCBAcCcaDA") == 10
  end

  test "check reduce/1 logic" do
    assert Day05.reduce(~w(a A)) == []
    assert Day05.reduce(~w(a b B A)) == []
    assert Day05.reduce(~w(a b B A)) == []
    assert Day05.reduce(~w(a b A B)) == ~w(a b A B)
    assert Day05.reduce(~w(a a b A A B)) == ~w(a a b A A B)
  end
end
