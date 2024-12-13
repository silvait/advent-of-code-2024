defmodule AdventOfCode.Day07 do
  @moduledoc false

  def part1(input_file) do
    solve(input_file, [&Kernel.+/2, &Kernel.*/2])
  end

  def part2(input_file) do
    solve(input_file, [&Kernel.+/2, &Kernel.*/2, &concat_numbers/2])
  end

  defp solve(input_file, operators) do
    input_file
    |> read_lines()
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn num -> valid_equation?(num, operators) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp read_lines(input_file) do
    File.read!(input_file) |> String.split("\n", trim: true)
  end

  defp parse_line(line) do
    [result, numbers] = String.split(line, ":")

    result = String.to_integer(result)
    numbers = String.split(numbers) |> Enum.map(&String.to_integer/1)

    {result, numbers}
  end

  defp valid_equation?({result, [first | rest]}, operators) do
    do_math(result, rest, first, operators)
  end

  defp do_math(result, [], acc, _), do: result == acc
  defp do_math(result, _, acc, _) when acc > result, do: false

  defp do_math(result, [num | rest], acc, operators) do
    Enum.any?(operators, fn op ->
      do_math(result, rest, op.(acc, num), operators)
    end)
  end

  defp concat_numbers(num1, num2) do
    (Integer.to_string(num1) <> Integer.to_string(num2)) |> String.to_integer()
  end
end
