defmodule AdventOfCode.Day01 do
  @moduledoc false

  defp parse_number_pair(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp read_file(file) do
    case File.read(file) do
      {:ok, contents} -> contents
      {:error, reason} -> raise "Failed to read file '#{file}': #{reason}"
    end
  end

  defp parse_lists(contents) do
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_number_pair/1)
    |> Enum.unzip()
  end

  defp calculate_list_distance({col1, col2}) do
    col1 = Enum.sort(col1)
    col2 = Enum.sort(col2)

    calculate_distance = &abs(&1 - &2)

    Enum.zip_with(col1, col2, calculate_distance)
    |> Enum.sum()
  end

  def part1(input_file) do
    input_file
    |> read_file()
    |> parse_lists()
    |> calculate_list_distance()
  end

  def calculate_list_similarity_score({col1, col2}) do
    frequencies = Enum.frequencies(col2)

    Enum.map(col1, fn n -> n * Map.get(frequencies, n, 0) end)
    |> Enum.sum()
  end

  def part2(input_file) do
    input_file
    |> read_file()
    |> parse_lists()
    |> calculate_list_similarity_score()
  end
end
