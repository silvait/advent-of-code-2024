defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day6_sample.txt"
    result = part1(input)

    assert result == 41
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day6_input.txt"
    result = part1(input)

    assert result == 5564
  end

  test "part 2 sample" do
    input = "#{__DIR__}/fixtures/day6_sample.txt"
    result = part2(input)

    assert result == 6
  end

  @tag :skip
  test "part 2 input" do
    input = "#{__DIR__}/fixtures/day6_input.txt"
    result = part2(input)

    assert result == 1976
  end
end
