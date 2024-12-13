defmodule AdventOfCode.Day08 do
  @moduledoc false

  def part1(input_file), do: solve(input_file, 1)

  def part2(input_file), do: solve(input_file, nil)

  def solve(input_file, depth) do
    input_file
    |> read_lines()
    |> build_grid()
    |> count_anti_nodes(depth)
  end

  defp read_lines(input_file) do
    input_file |> File.read!() |> String.split("\n", trim: true)
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

  defp find_antennas(grid), do: Enum.reject(grid, fn {_, tile} -> tile == "." end)

  defp invalid_location?(grid, location), do: Map.get(grid, location) == nil

  defp count_anti_nodes(grid, depth) do
    grid
    |> find_antennas()
    |> find_anti_nodes(depth, [])
    |> Enum.reject(&invalid_location?(grid, &1))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp find_anti_nodes([], _depth, anti_nodes), do: anti_nodes

  defp find_anti_nodes([{location, antenna} | rest], depth, anti_nodes) do
    new_anti_nodes =
      Enum.filter(rest, fn {_, other_antenna} -> other_antenna == antenna end)
      |> Enum.flat_map(&calculate_anti_node_locations(elem(&1, 0), location, depth))

    find_anti_nodes(rest, depth, new_anti_nodes ++ anti_nodes)
  end

  defp calculate_anti_node_locations({x1, y1}, {x2, y2}, depth) do
    {rise, run} = {y2 - y1, x2 - x1}

    if depth == 1 do
      [{x1 - run, y1 - rise}, {x2 + run, y2 + rise}]
    else
      expand_left(rise, run, {x1, y1}, []) ++ expand_right(rise, run, {x1, y1}, [])
    end
  end

  defp expand_left(_, _, {x1, y1}, acc) when x1 < 0 or y1 < 0 or x1 > 49 or y1 > 49, do: acc
  defp expand_left(rise, run, {x1, y1}, acc) do
    expand_left(rise, run, {x1 - run, y1 - rise}, [{x1, y1} | acc])
  end

  defp expand_right(_, _, {x1, y1}, acc) when x1 < 0 or y1 < 0 or x1 > 49 or y1 > 49, do: acc
  defp expand_right(rise, run, {x1, y1}, acc) do
    expand_right(rise, run, {x1 + run, y1 + rise} , [{x1, y1} | acc])
  end
end
