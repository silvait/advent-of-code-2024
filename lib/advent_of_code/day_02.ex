defmodule AdventOfCode.Day02 do
  defp read_file(file) do
    case File.read(file) do
      {:ok, contents} -> contents
      {:error, reason} -> raise "Failed to read file '#{file}': #{reason}"
    end
  end

  defp parse_numbers(str) do
    String.split(str) |> Enum.map(&String.to_integer/1)
  end

  defp is_safe_level(levels) do
    deltas = calculate_deltas(levels)

    (Enum.all?(deltas, fn x -> x > 0 end) || Enum.all?(deltas, fn x -> x < 0 end)) &&
      Enum.all?(deltas, fn x -> abs(x) <= 3 end)
  end

  defp generate_sublists(list) do
    Enum.map(0..(length(list) - 1), fn index ->
      List.delete_at(list, index)
    end)
  end

  defp is_tolerable_safe_level(levels) do
    is_safe_level(levels) || generate_sublists(levels) |> Enum.any?(&is_safe_level/1)
  end

  def calculate_deltas(levels) do
    Enum.chunk_every(levels, 2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  defp count_safe_levels(levels) do
    levels
    |> Enum.filter(&is_safe_level/1)
    |> length()
  end

  defp count_tolerable_safe_levels(levels) do
    levels
    |> Enum.filter(&is_tolerable_safe_level/1)
    |> length()
  end

  def part1(input_file) do
    input_file
    |> read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_numbers/1)
    |> count_safe_levels()
  end

  def part2(input_file) do
    input_file
    |> read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_numbers/1)
    |> count_tolerable_safe_levels()
  end
end
