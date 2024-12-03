defmodule AdventOfCode.Day03 do
  defp translate_operation(operation) do
    case operation do
      ["do()"] -> :enabled
      ["don't()"] -> :disabled
      [_, num1, num2] -> {String.to_integer(num1), String.to_integer(num2)}
    end
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
    |> Enum.sum()
  end

  defp perform_operations2(operations) do
    {_, result} =
      Enum.reduce(operations, {:enabled, 0}, fn token, {status, result} ->
        case [status, token] do
          [:disabled, {_, _}] -> {status, result}
          [:enabled, {x, y}] -> {status, result + x * y}
          [_, new_status] -> {new_status, result}
        end
      end)

    result
  end

  def part1(input) do
    input
    |> parse_operations()
    |> perform_operations()
  end

  def part2(input) do
    input
    |> parse_operations2()
    |> perform_operations2()
  end
end
