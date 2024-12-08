defmodule AdventOfCode.Day08 do
  def part1(input_file) do
    input_file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> build_grid()
    |> count_anti_nodes()
  end

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

  defp find_antennas(grid) do
    Enum.reject(grid, fn ({_, tile}) -> tile == "." end)
  end

  defp count_anti_nodes(grid) do
    grid
    |> find_antennas()
    |> then(fn a -> find_anti_nodes(grid, a, []) end)
    |> Enum.reject(fn location -> Map.get(grid, location) == nil end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp find_anti_nodes(_grid, [], anti_nodes), do: anti_nodes

  defp find_anti_nodes(grid, [{ location, antenna } | rest], anti_nodes) do
    new_nodes = Enum.filter(rest, fn {_, tile} -> tile == antenna end)
    |> Enum.flat_map(fn { other_location, _ } -> calculate_anti_node_locations(location, other_location) end)

    find_anti_nodes(grid, rest, new_nodes ++ anti_nodes)
  end

  def calculate_anti_node_locations({x1,y1} , {x2, y2} ) do
    [{x1, y1}, {x2, y2}] = if x2 < x1 do
      [{x2, y2}, {x1, y1}]
    else
      [{x1, y1}, {x2, y2}]
    end

    rise = y2 - y1
    run = x2 - x1

    location1 = {(x1 - run), (y1 - rise)}
    location2 = {(x2 + run), (y2 + rise)}

    [location1, location2]
  end

  def part2(_args) do
  end
end
