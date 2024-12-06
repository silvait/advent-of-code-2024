defmodule AdventOfCode.Day06 do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}

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
    |> Enum.flat_map(&parse_row/1)
    |> Map.new()
  end

  defp parse_row({line, row}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, col} -> {{row, col}, char} end)
  end

  defp turn_right(direction) do
    case direction do
      @north -> @east
      @east -> @south
      @south -> @west
      @west -> @north
    end
  end

  defp process_map(map) do
    start = find_start_position(map)

    walk_map(map, start, @north, MapSet.new())
    |> Enum.count()
  end

  defp walk_map(map, {row, col}, {dir_row, dir_col}, seen) do
    case Map.get(map, {row, col}) do
      nil ->
        seen

      tile when tile in [".", "^"] ->
        new_seen = MapSet.put(seen, {row, col})
        walk_map(map, {row + dir_row, col + dir_col}, {dir_row, dir_col}, new_seen)

      "#" ->
        {last_row, last_col} = {row - dir_row, col - dir_col}
        {new_dir_row, new_dir_col} = turn_right({dir_row, dir_col})

        walk_map(
          map,
          {last_row + new_dir_row, last_col + new_dir_col},
          {new_dir_row, new_dir_col},
          seen
        )
    end
  end

  def part2(_args) do
  end
end
