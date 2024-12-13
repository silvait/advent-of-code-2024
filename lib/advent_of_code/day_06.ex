defmodule AdventOfCode.Day06 do
  @moduledoc false

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
    |> travel_grid(start_position)
    |> count_unique_tiles()
  end

  defp count_unique_tiles(route), do: get_unique_tiles(route) |> MapSet.size()

  defp get_unique_tiles(route), do: Enum.map(route, &elem(&1, 0)) |> MapSet.new()

  defp travel_grid(grid, position, direction \\ @north, route \\ MapSet.new()) do
    tile = Map.get(grid, position)

    cond do
      MapSet.member?(route, {position, direction}) ->
        nil

      tile == nil ->
        route

      tile in [@empty_tile, @start_tile] ->
        new_visited = MapSet.put(route, {position, direction})
        travel_grid(grid, move_forward(position, direction), direction, new_visited)

      tile == @obstacle_tile ->
        last_position = move_back(position, direction)
        new_direction = turn_right(direction)

        travel_grid(grid, move_forward(last_position, new_direction), new_direction, route)
    end
  end

  defp find_start_position(grid) do
    grid
    |> Enum.find(fn {_k, v} -> v == @start_tile end)
    |> elem(0)
  end

  defp move_forward({x, y}, {direction_x, direction_y}), do: {x + direction_x, y + direction_y}

  defp move_back({x, y}, {direction_x, direction_y}), do: {x - direction_x, y - direction_y}

  defp turn_right({x, y}), do: {-y, x}

  def part2(input_file) do
    input_file
    |> read_lines()
    |> build_grid()
    |> count_loops()
  end

  defp count_loops(grid) do
    start_position = find_start_position(grid)

    route =
      travel_grid(grid, start_position)
      |> get_unique_tiles()
      |> MapSet.delete(start_position)

    Enum.count(route, fn position ->
      Map.put(grid, position, @obstacle_tile)
      |> travel_grid(start_position)
      |> is_nil()
    end)
  end
end
