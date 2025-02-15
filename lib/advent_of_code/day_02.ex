defmodule AdventOfCode.Day02 do
  @moduledoc false

  defp read_file(file) do
    case File.read(file) do
      {:ok, contents} -> contents
      {:error, reason} -> raise "Failed to read file '#{file}': #{reason}"
    end
  end

  defp parse_numbers(str) do
    str |> String.split() |> Enum.map(&String.to_integer/1)
  end

  defp safe_level?(levels) do
    deltas = calculate_deltas(levels)

    (all_ascending?(deltas) or all_descending?(deltas)) and
      Enum.all?(deltas, &(abs(&1) <= 3))
  end

  defp all_ascending?(deltas), do: Enum.all?(deltas, &(&1 > 0))

  defp all_descending?(deltas), do: Enum.all?(deltas, &(&1 < 0))

  defp generate_sublists(list) do
    Enum.with_index(list, fn _, index -> List.delete_at(list, index) end)
  end

  defp tolerable_safe_level?(levels) do
    safe_level?(levels) or Enum.any?(generate_sublists(levels), &safe_level?/1)
  end

  def calculate_deltas(levels) do
    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  def part1(input_file) do
    input_file
    |> read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_numbers/1)
    |> Enum.count(&safe_level?/1)
  end

  def part2(input_file) do
    input_file
    |> read_file()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_numbers/1)
    |> Enum.count(&tolerable_safe_level?/1)
  end
end
