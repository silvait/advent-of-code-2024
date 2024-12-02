defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day1_sample1.txt"
    result = part1(input)

    assert result == 11
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day1_input.txt"
    result = part1(input)

    assert result == 936063
  end

  test "part2 sample" do
    input = "#{__DIR__}/fixtures/day1_sample2.txt"
    result = part2(input)

    assert result == 31
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day1_input.txt"
    result = part2(input)

    assert result == 23150395
  end
end
