defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day4_sample1.txt"
    result = part1(input)

    assert result == 18
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day4_input.txt"
    result = part1(input)

    assert result == 2462
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
