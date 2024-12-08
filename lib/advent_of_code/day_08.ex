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
    Enum.reject(grid, fn {_, tile} -> tile == "." end)
  end

  defp invalid_location?(grid, location) do
    Map.get(grid, location) == nil
  end

  defp count_anti_nodes(grid) do
    grid
    |> find_antennas()
    |> find_anti_nodes([])
    |> Enum.reject(&invalid_location?(grid, &1))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp find_anti_nodes([], anti_nodes), do: anti_nodes

  defp find_anti_nodes([{{x1, y1}, antenna} | rest], anti_nodes) do
    new_nodes =
      Enum.filter(rest, fn {_, tile} -> tile == antenna end)
      |> Enum.flat_map(fn {{x2, y2}, _} ->
        {rise, run} = {y2 - y1, x2 - x1}
        [{x1 - run, y1 - rise}, {x2 + run, y2 + rise}]
      end)

    find_anti_nodes(rest, new_nodes ++ anti_nodes)
  end

  def part2(_args) do
  end
end
