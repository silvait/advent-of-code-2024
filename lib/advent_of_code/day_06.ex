defmodule AdventOfCode.Day06 do
  @north {0, -1}

  @obstacle_tile "#"
  @empty_tile "."
  @start_tile "^"

  def part1(input_file) do
    input_file
    |> read_lines()
    |> build_grid()
    |> calculate_route_length()
  end

  defp read_lines(input_file), do: File.read!(input_file) |> String.split("\n", trim: true)

  defp build_grid(lines) do
    Enum.with_index(lines)
    |> Enum.flat_map(&parse_grid_line/1)
    |> Map.new()
  end

  defp parse_grid_line({line, y}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {tile, x} -> {{x, y}, tile} end)
  end

  defp calculate_route_length(grid) do
    start_position = find_start_position(grid)

    grid
    |> walk_grid(start_position)
    |> count_unique_tiles()
  end

  defp count_unique_tiles(route) do
    route
    |> get_unique_tiles()
    |> Enum.count()
  end

  defp get_unique_tiles(route) do
    route
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
  end

  defp walk_grid(grid, position, direction \\ @north, visited \\ MapSet.new()) do
    if MapSet.member?(visited, {position, direction}) do
      nil
    else
      case Map.get(grid, position) do
        nil ->
          visited

        tile when tile in [@empty_tile, @start_tile] ->
          new_visited = MapSet.put(visited, {position, direction})
          walk_grid(grid, step_forward(position, direction), direction, new_visited)

        @obstacle_tile ->
          last_position = step_back(position, direction)
          new_direction = turn_right(direction)

          walk_grid(grid, step_forward(last_position, new_direction), new_direction, visited)
      end
    end
  end

  defp find_start_position(grid) do
    grid
    |> Enum.find(fn {_k, v} -> v == @start_tile end)
    |> elem(0)
  end

  defp step_forward({x, y}, {direction_x, direction_y}), do: {x + direction_x, y + direction_y}

  defp step_back({x, y}, {direction_x, direction_y}), do: {x - direction_x, y - direction_y}

  defp turn_right({x, y}), do: {-y, x}

  def part2(input_file) do
    input_file
    |> read_lines()
    |> build_grid()
    |> count_loops()
  end


  defp count_loops(grid) do
    start_position = find_start_position(grid)

    route = walk_grid(grid, start_position)
    |> get_unique_tiles()
    |> List.delete(start_position)

    Enum.count(route, fn position ->
      Map.put(grid, position, @obstacle_tile)
      |> walk_grid(start_position)
      |> is_nil()
    end)
  end
end
