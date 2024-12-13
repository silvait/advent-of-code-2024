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

  test "part2 sample A" do
    input = "#{__DIR__}/fixtures/day12_sample_a.txt"
    result = part2(input)

    assert result == 80
  end

  test "part2 sample B" do
    input = "#{__DIR__}/fixtures/day12_sample_b.txt"
    result = part2(input)

    assert result == 436
  end

  test "part2 sample D" do
    input = "#{__DIR__}/fixtures/day12_sample_d.txt"
    result = part2(input)

    assert result == 236
  end

  test "part2 sample E" do
    input = "#{__DIR__}/fixtures/day12_sample_e.txt"
    result = part2(input)

    assert result == 368
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day12_input.txt"
    result = part2(input)

    assert result == 811148
  end
end
