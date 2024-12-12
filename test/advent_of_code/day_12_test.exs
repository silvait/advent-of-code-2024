defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1 sample A" do
    input = "#{__DIR__}/fixtures/day12_sample_a.txt"
    result = part1(input)

    assert result == 140
  end

  test "part1 sample B" do
    input = "#{__DIR__}/fixtures/day12_sample_b.txt"
    result = part1(input)

    assert result == 772
  end

  test "part1 sample C" do
    input = "#{__DIR__}/fixtures/day12_sample_c.txt"
    result = part1(input)

    assert result == 1930
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day12_input.txt"
    result = part1(input)

    assert result == 1304764
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
