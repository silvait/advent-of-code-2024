defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.Day14

  test "part1" do
    input = "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"

    result = part1(input, {11, 7})

    assert result == 12
  end

  test "part1 input" do
    input = File.read!("#{__DIR__}/fixtures/day14_input.txt")
    result = part1(input, {101, 103})

    assert result == 229_980_828
  end

  test "part2 input" do
    input = File.read!("#{__DIR__}/fixtures/day14_input.txt")
    result = part2(input, {101, 103})

    assert result == 7_132
  end
end
