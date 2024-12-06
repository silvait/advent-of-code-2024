defmodule AdventOfCode.Day06 do
  @north {0, -1}
  @east {1, 0}
  @south {0, 1}
  @west {-1, 0}

  @obstacle "#"
  @space "."
  @start "^"

  def part1(input_file) do
    input_file
    |> read_lines()
    |> build_map()
    |> process_map()
  end

  defp read_lines(input_file) do
    input_file |> File.read!() |> String.split("\n", trim: true)
  end

  defp find_start_position(map) do
    Enum.find(map, fn {_, v} -> v == @start end) |> elem(0)
  end

  defp build_map(lines) do
    Enum.with_index(lines)
    |> Enum.flat_map(&parse_row/1)
    |> Map.new()
  end

  defp parse_row({line, y}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, x} -> {{x, y}, char} end)
  end

  defp turn_right(direction) do
    case direction do
      @north -> @east
      @east -> @south
      @south -> @west
      @west -> @north
    end
  end

  defp step_forward({x, y}, {direction_x, direction_y}) do
    {x + direction_x, y + direction_y}
  end

  defp step_back({x, y}, {direction_x, direction_y}) do
    {x - direction_x, y - direction_y}
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
        new_visited = MapSet.put(visited, position)
        walk_map(map, step_forward(position, direction), direction, new_visited)

      @obstacle ->
        last_position = step_back(position, direction)
        new_direction = turn_right(direction)

        walk_map(map, step_forward(last_position, new_direction), new_direction, visited)
    end
  end

  def part2(input_file) do
    input_file
    |> read_lines()
    |> build_map()

    0
  end
end
