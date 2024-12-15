defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  test "part1 sample A" do
    input = "#{__DIR__}/fixtures/day15_sample_a.txt"
    result = part1(input)

    assert result == 2028
  end

  test "part1 sample B" do
    input = "#{__DIR__}/fixtures/day15_sample_b.txt"
    result = part1(input)

    assert result == 10_092
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day15_input.txt"
    result = part1(input)

    assert result == 1_436_690
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result == 9021
  end
end
