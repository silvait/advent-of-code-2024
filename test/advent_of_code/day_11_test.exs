defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "part1 sample" do
    input = "125 17"
    result = part1(input)

    assert result == 55312
  end

  @tag timeout: :infinity
  test "part1 input" do
    input = "773 79858 0 71 213357 2937 1 3998391"
    result = part1(input)

    assert result == 199982
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
