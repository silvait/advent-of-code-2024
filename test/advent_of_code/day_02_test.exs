defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day2_sample1.txt"
    result = part1(input)

    assert result == 2
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day2_input.txt"
    result = part1(input)

    assert result == 479
  end

  test "part2 sample" do
    input = "#{__DIR__}/fixtures/day2_sample1.txt"
    result = part2(input)

    assert result == 4
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day2_input.txt"
    result = part2(input)

    assert result == 531
  end
end
