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

  test "part2 sample" do
    input = "#{__DIR__}/fixtures/day4_sample1.txt"
    result = part2(input)

    assert result == 9
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day4_input.txt"
    result = part2(input)

    assert result == 1877
  end
end
