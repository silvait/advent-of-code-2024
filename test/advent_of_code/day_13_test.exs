defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  test "part1 sample" do
    input = "#{__DIR__}/fixtures/day13_sample.txt"
    result = part1(input)

    assert result == 480
  end

  test "part1 input" do
    input = "#{__DIR__}/fixtures/day13_input.txt"
    result = part1(input)

    assert result == 28_262
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day13_input.txt"
    result = part2(input)

    assert result == 101_406_661_266_314
  end
end
