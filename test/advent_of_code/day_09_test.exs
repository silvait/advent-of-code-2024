defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1 sample" do
    input = "2333133121414131402"
    result = part1(input)

    assert result == 1928
  end

  test "part1 input" do
    input = File.read!("#{__DIR__}/fixtures/day9_input.txt")
    result = part1(input)

    assert result == 6283170117911
  end

  test "part2 sample" do
    input = "2333133121414131402"
    result = part2(input)

    assert result == 2858
  end

  test "part2 input" do
    input = File.read!("#{__DIR__}/fixtures/day9_input.txt")
    result = part2(input)

    assert result == 6307653242596
  end
end
