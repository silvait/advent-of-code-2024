defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day5_sample.txt"
    result = part1(input)

    assert result == 143
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day5_input.txt"
    result = part1(input)

    assert result == 4637
  end

  test "part2 sample" do
    input = "#{__DIR__}/fixtures/day5_sample.txt"
    result = part2(input)

    assert result == 123
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day5_input.txt"
    result = part2(input)

    assert result == 123
  end
end
