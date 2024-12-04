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
    lines ++ columns(lines) ++ diagonals(lines, :right) ++ diagonals(lines, :left)
  end

  def diagonals(lines, direction) do
    total_columns = String.length(Enum.at(lines, 0))
    total_rows = Enum.count(lines)

    [inc, start_col] =
      case direction do
        :right -> [{1, 1}, 0]
        :left -> [{1, -1}, total_columns - 1]
      end

    first =
      Enum.map(
        0..(total_columns - 1),
        &walk_diagonal(lines, {0, &1}, total_rows, total_columns, inc)
      )

    second =
      Enum.map(
        1..(total_rows - 1),
        &walk_diagonal(lines, {&1, start_col}, total_rows, total_columns, inc)
      )

    first ++ second
  end

  defp walk_diagonal(_, {row, col}, total_rows, total_columns, _)
       when row < 0 or col < 0 or row >= total_rows or col >= total_columns do
    ""
  end

  defp walk_diagonal(lines, {row, col}, total_rows, total_columns, {row_inc, col_inc}) do
    current_string = Enum.at(lines, row)
    current_letter = String.at(current_string, col)

    current_letter <>
      walk_diagonal(
        lines,
        {row + row_inc, col + col_inc},
        total_rows,
        total_columns,
        {row_inc, col_inc}
      )
  end

  defp columns(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&(Tuple.to_list(&1) |> Enum.join("")))
  end

  defp count_matches(line, pattern) do
    Regex.scan(pattern, line) |> Enum.count()
  end

  def part2(_args) do
  end
end
