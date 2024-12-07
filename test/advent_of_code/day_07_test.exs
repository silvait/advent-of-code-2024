defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day7_sample.txt"
    result = part1(input)

    assert result == 3749
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day7_input.txt"
    result = part1(input)

    assert result == 5540634308362
  end

  test "part2" do
    input = "#{__DIR__}/fixtures/day7_sample.txt"
    result = part2(input)

    assert result == 11387
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day7_input.txt"
    result = part2(input)

    assert result == 472290821152397
  end
end
