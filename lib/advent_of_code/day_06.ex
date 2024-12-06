defmodule AdventOfCode.Day06 do
  @north {-1, 0}
  @east {0, 1}
  @south {1, 0}
  @west {0, -1}

  @obstacle "#"
  @space "."
  @start "^"

  def part1(input_file) do
    File.read!(input_file)
    |> String.split("\n", trim: true)
    |> build_map()
    |> process_map()
  end

  defp find_start_position(map) do
    Enum.find(map, fn {_, v} -> v == @start end) |> elem(0)
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

  defp step_forward({row, col}, {dir_row, dir_col}) do
    {row + dir_row, col + dir_col}
  end

  defp step_back({row, col}, {dir_row, dir_col}) do
    {row - dir_row, col - dir_col}
  end

  defp process_map(map) do
    start = find_start_position(map)

    map
    |> walk_map(start, @north)
    |> Enum.count()
  end

  defp walk_map(map, position, direction, visited \\ MapSet.new()) do
    case Map.get(map, position) do
      nil ->
        visited

      tile when tile in [@space, @start] ->
        new_seen = MapSet.put(visited, position)
        walk_map(map, step_forward(position, direction), direction, new_seen)

      @obstacle ->
        last_position = step_back(position, direction)
        new_direction = turn_right(direction)

        walk_map(map, step_forward(last_position, new_direction), new_direction, visited)
    end
  end

  def part2(_args) do
  end
end
