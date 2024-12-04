defmodule AdventOfCode.Day04 do
  @pattern ~r/(?=(XMAS|SAMX))/

  def part1(input_file) do
    input_file
    |> read_lines()
    |> search_lines(@pattern)
  end

  defp read_lines(input_file) do
    input_file
    |> File.read!()
    |> String.split("\n")
  end

  defp search_lines(lines, pattern) do
    lines
    |> create_search_paths()
    |> Enum.map(&count_matches(&1, pattern))
    |> Enum.sum()
  end

  defp create_search_paths(lines) do
    lines ++ columns(lines) ++ diagonals(lines) ++ diagonals(reversed(lines))
  end

  def diagonals(lines) do
    total_columns = String.length(Enum.at(lines, 0))
    first_row = MapSet.new(0..(total_columns - 1), &{0, &1})

    total_rows = Enum.count(lines)
    first_column = MapSet.new(0..(total_rows - 1), &{&1, 0})

    start_list = MapSet.union(first_row, first_column)

    Enum.map(start_list, fn {row, col} ->
      walk_diagonal(Enum.drop(lines, row), col, total_columns)
    end)
  end

  defp walk_diagonal([current_line | lines], col, total_columns) when col < total_columns do
    String.at(current_line, col) <> walk_diagonal(lines, col + 1, total_columns)
  end

  defp walk_diagonal(_, _, _), do: ""

  defp reversed(lines), do: Enum.map(lines, &String.reverse/1)

  defp columns(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&(Tuple.to_list(&1) |> Enum.join("")))
  end

  defp count_matches(line, pattern), do: Regex.scan(pattern, line) |> Enum.count()

  def part2(_args) do
  end
end
