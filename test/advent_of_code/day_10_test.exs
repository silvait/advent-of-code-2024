defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day10_sample.txt"
    result = part1(input)

    assert result == 36
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day10_input.txt"
    result = part1(input)

    assert result == 593
  end

  test "part2" do
    input = "#{__DIR__}/fixtures/day10_sample.txt"
    result = part2(input)

    assert result == 81
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day10_input.txt"
    result = part2(input)

    assert result == 1192
  end
end
