defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "part1 sample" do
    cpu = %CPU{
      register_a: 729,
      instructions: [0, 1, 5, 4, 3, 0]
    }

    result = part1(cpu)

    assert result == [4, 6, 3, 5, 6, 3, 5, 2, 1, 0]
  end

  test "part1 input" do
    cpu = %CPU{
      register_a: 64_584_136,
      instructions: [2, 4, 1, 2, 7, 5, 1, 3, 4, 3, 5, 5, 0, 3, 3, 0]
    }

    result = part1(cpu)

    assert result == [3, 7, 1, 7, 2, 1, 0, 6, 3]
  end

  test "part2 sample" do
    result = part2([0, 3, 5, 4, 3, 0])

    assert result.register_a == 117_440
  end

  test "part2 input" do
    result = part2([2, 4, 1, 2, 7, 5, 1, 3, 4, 3, 5, 5, 0, 3, 3, 0])

    assert result.register_a == 37_221_334_433_268
  end
end
