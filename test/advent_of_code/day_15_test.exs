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

  test "part2 sample B" do
    input = "#{__DIR__}/fixtures/day15_sample_b.txt"
    result = part2(input)

    assert result == 9021
  end

  test "part2 sample C" do
    input = "#{__DIR__}/fixtures/day15_sample_c.txt"
    result = part2(input)

    assert result == 618
  end

  test "part2 input" do
    input = "#{__DIR__}/fixtures/day15_input.txt"
    result = part2(input)

    assert result == 1_482_350
  end
end
