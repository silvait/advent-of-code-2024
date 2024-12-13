defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "part1 sample" do
    input = "125 17"
    result = part1(input)

    assert result == 55_312
  end

  test "part1 input" do
    input = "773 79858 0 71 213357 2937 1 3998391"
    result = part1(input)

    assert result == 199_982
  end

  test "part2 input" do
    input = "773 79858 0 71 213357 2937 1 3998391"
    result = part2(input)

    assert result == 237_149_922_829_154
  end
end
