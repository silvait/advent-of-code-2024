defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day8_sample.txt"
    result = part1(input)

    assert result == 14
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day8_input.txt"
    result = part1(input)

    assert result == 247
  end

  test "part2 sample" do
    input = "#{__DIR__}/fixtures/day8_sample.txt"
    result = part2(input)

    assert result == 34
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day8_input.txt"
    result = part2(input)

    assert result == 861
  end
end
