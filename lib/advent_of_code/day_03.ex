defmodule AdventOfCode.Day03 do
  defp translate_operation([operation]) do
    case operation do
      "do()" -> :enable
      "don't()" -> :disable
    end
  end

  defp translate_operation([_, num1, num2]) do
    {String.to_integer(num1), String.to_integer(num2)}
  end

  defp parse_operations(str) do
    regex = ~r/mul\((\d+),(\d+)\)/

    Regex.scan(regex, str)
    |> Enum.map(fn [_, num1, num2] ->
      {String.to_integer(num1), String.to_integer(num2)}
    end)
  end

  defp parse_operations2(str) do
    regex = ~r/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/

    Regex.scan(regex, str)
    |> Enum.map(&translate_operation/1)
  end

  defp perform_operations(operations) do
    Enum.map(operations, fn {x, y} -> x * y end)
  end

  defp perform_operations2(operations) do
    {_, result} = Enum.reduce(operations, { true, 0 }, fn token, {status, result} ->
      case [token, status] do
        [:disable,_] -> {false, result}
        [:enable,_] -> {true, result}
        [_, false] -> {status, result}
        [{x,y}, true] -> {status, (result + (x * y))}
      end
    end)

    result
  end

  def part1(input) do
    input
    |> parse_operations()
    |> perform_operations()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_operations2()
    |> perform_operations2()
  end
end
