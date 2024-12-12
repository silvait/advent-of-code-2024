defmodule AdventOfCode.Day12 do
  def part1(input_file) do
    input_file
    |> read_lines()
    |> parse_grid()
    |> find_regions()
    |> calculate_fence_cost()
  end

  defp read_lines(input_file) do
    File.read!(input_file) |> String.split("\n", trim: true)
  end

  defp parse_grid(lines) do
    lines
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
    |> Map.new()
  end

  defp parse_line({line, y}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {label, x} -> {{x, y}, label} end)
  end

  defp find_regions(grid) do
    Enum.reduce(grid, {[], MapSet.new()}, fn {tile, _}, {regions, seen} ->
      if MapSet.member?(seen, tile) do
        {regions, seen}
      else
        {region, _} = walk_region(grid, tile, [], MapSet.new())
        new_seen = Enum.map(region, &elem(&1, 0)) |> MapSet.new()

        {[region | regions], MapSet.union(seen, new_seen)}
      end
    end)
    |> elem(0)
  end

  defp walk_region(grid, {x, y}, region, seen) do
    if MapSet.member?(seen, {x, y}) do
      {region, seen}
    else
      candidate_tiles = [{x - 1, y}, {x, y - 1}, {x + 1, y}, {x, y + 1}]
      current_label = Map.get(grid, {x, y})
      neighbors = Enum.reject(candidate_tiles, &(Map.get(grid, &1) != current_label))

      perimeter = 4 - Enum.count(neighbors)
      current_region = [{{x, y}, perimeter} | region]
      current_seen = MapSet.put(seen, {x, y})

      Enum.reduce(neighbors, {current_region, current_seen}, fn c, {r, s} ->
        walk_region(grid, c, r, s)
      end)
    end
  end

  def calculate_fence_cost(regions) do
    Enum.reduce(regions, 0, fn r, total ->
      total + calculate_region_area(r) * calculate_region_perimeter(r)
    end)
  end

  def calculate_region_area(region), do: Enum.count(region)

  def calculate_region_perimeter(region) do
    region
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(_args) do
  end
end
