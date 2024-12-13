defmodule AdventOfCode.Day13 do
  @moduledoc false

  @button_a_cost 3
  @button_b_cost 1
  @prize_offset 10_000_000_000_000

  def part1(input_file) do
    solve(input_file, 0)
  end

  def part2(input_file) do
    solve(input_file, @prize_offset)
  end

  def solve(input_file, offset) do
    input_file
    |> File.read!()
    |> parse_input()
    |> Enum.map(&add_prize_offset(&1, offset))
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_machine/1)
  end

  defp parse_machine(line) do
    [button_a, button_b, prize] =
      line
      |> String.split("\n")
      |> Enum.map(&(String.split(&1, ": ") |> Enum.at(1)))

    {parse_button(button_a), parse_button(button_b), parse_prize(prize)}
  end

  defp parse_button(button) do
    button
    |> String.split(", ")
    |> Enum.map(&(String.slice(&1, 2..-1//1) |> String.to_integer()))
    |> List.to_tuple()
  end

  defp parse_prize(prize) do
    prize
    |> String.split(", ")
    |> Enum.map(&(String.split(&1, "=") |> Enum.at(1) |> String.to_integer()))
    |> List.to_tuple()
  end

  defp add_prize_offset({button_a, button_b, {prize_x, prize_y}}, offset) do
    {button_a, button_b, {prize_x + offset, prize_y + offset}}
  end

  def whole_number?(number) when is_float(number) do
    number == Float.floor(number)
  end

  def solve({{a_x, a_y}, {b_x, b_y}, {prize_x, prize_y}}) do
    count_a = (prize_x * b_y - prize_y * b_x) / (a_x * b_y - a_y * b_x)
    count_b = (prize_x - a_x * count_a) / b_x

    counts =
      if whole_number?(count_a) and whole_number?(count_b) do
        {count_a, count_b}
      end

    calculate_cost(counts)
  end

  defp calculate_cost(nil), do: 0
  defp calculate_cost({count_a, count_b}), do: count_a * @button_a_cost + count_b * @button_b_cost
end
