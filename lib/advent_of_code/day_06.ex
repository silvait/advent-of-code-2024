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
    |> build_grid()
    |> process_grid()
  end

  defp read_lines(input_file), do: File.read!(input_file ) |> String.split("\n", trim: true)

  defp build_grid(lines) do
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

  defp process_grid(grid) do
    start_position = find_start_position(grid)

    grid
    |> walk_grid(start_position, @north)
    |> Enum.count()
  end

  defp walk_grid(grid, position, direction, visited \\ MapSet.new()) do
    case Map.get(grid, position) do
      nil ->
        visited

      tile when tile in [@space, @start] ->
        new_visited = MapSet.put(visited, position)
        walk_grid(grid, step_forward(position, direction), direction, new_visited)

      @obstacle ->
        last_position = step_back(position, direction)
        new_direction = turn_right(direction)

        walk_grid(grid, step_forward(last_position, new_direction), new_direction, visited)
    end
  end

  defp find_start_position(grid), do: Enum.find(grid, fn {_k, v} -> v == @start end) |> elem(0)

  defp step_forward({x, y}, {direction_x, direction_y}), do: {x + direction_x, y + direction_y}

  defp step_back({x, y}, {direction_x, direction_y}), do: {x - direction_x, y - direction_y}

  defp turn_right(direction) do
    case direction do
      @north -> @east
      @east -> @south
      @south -> @west
      @west -> @north
    end
  end

  def part2(input_file) do
    input_file
    |> read_lines()
    |> build_grid()
    |> process_grid()
  end
end
