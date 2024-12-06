defmodule AdventOfCode.Day06 do
  def part1(input_file) do
    File.read!(input_file)
    |> String.split("\n", trim: true)
    |> build_map()
    |> process_map()
  end

  defp find_start_position(map) do
    Enum.find(map, fn {_, v} -> v == "^" end) |> elem(0)
  end

  defp build_map(lines) do
    Enum.with_index(lines)
    |> Enum.flat_map(fn { l, row } ->
      Enum.with_index(String.graphemes(l))
      |> Enum.map(fn {c, col} ->
        { {row,col}, c }
      end)
    end)
    |> Map.new()
  end

  defp turn_right(direction) do
    case direction do
      {-1, 0} -> {0, 1}
      {0, 1} -> {1, 0}
      {1, 0} -> {0, -1}
      {0, -1} -> {-1, 0}
    end
  end

  defp process_map(map) do
    start = find_start_position(map)

    walk_map(map, start, {-1, 0}, MapSet.new())
    |> Enum.count()
  end

  defp walk_map(map, {row, col}, {dir_row, dir_col}, seen) do
    current_tile = Map.get(map, {row, col})

    case current_tile do
      nil -> seen
      tile when tile in [".", "^"] ->
        new_seen = MapSet.put(seen, {row, col})
        walk_map(map, {row + dir_row, col + dir_col}, {dir_row, dir_col}, new_seen)
      "#" ->
        {last_row, last_col} = {row - dir_row, col - dir_col}
        {new_dir_row, new_dir_col} = turn_right({dir_row, dir_col})
        walk_map(map, {last_row + new_dir_row, last_col + new_dir_col}, {new_dir_row, new_dir_col}, seen)
    end
  end

  def part2(_args) do
  end
end
