defmodule AdventOfCode.Day12 do
  @north {0, -1}
  @northeast {1, -1}
  @east {1, 0}
  @southeast {1, 1}
  @south {0, 1}
  @southwest {-1, 1}
  @west {-1, 0}
  @northwest {-1, -1}

  @adjacent4 [@north, @east, @south, @west]

  @corners [
    [@north, @northeast, @east],
    [@east, @southeast, @south],
    [@south, @southwest, @west],
    [@west, @northwest, @north]
  ]

  def part1(input_file) do
    input_file
    |> read_lines()
    |> parse_grid()
    |> find_regions()
    |> calculate_fence_cost()
  end

  def part2(input_file) do
    input_file
    |> read_lines()
    |> parse_grid()
    |> find_regions()
    |> calculate_fence_bulk_cost()
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
        new_region = walk_region(grid, tile)
        {[new_region | regions], MapSet.union(seen, MapSet.new(new_region))}
      end
    end)
    |> elem(0)
  end

  defp walk_region(grid, location) do
    do_walk_region(grid, location, [], MapSet.new())
    |> elem(0)
  end

  defp do_walk_region(grid, {x, y}, region, seen) do
    if MapSet.member?(seen, {x, y}) do
      {region, seen}
    else
      candidate_tiles = Enum.map(@adjacent4, fn {dx, dy} -> {x + dx, y + dy} end)
      current_label = Map.get(grid, {x, y})
      neighbors = Enum.reject(candidate_tiles, &(Map.get(grid, &1) != current_label))

      current_region = [{x, y} | region]
      current_seen = MapSet.put(seen, {x, y})

      Enum.reduce(neighbors, {current_region, current_seen}, fn c, {r, s} ->
        do_walk_region(grid, c, r, s)
      end)
    end
  end

  def calculate_fence_cost(regions) do
    Enum.reduce(regions, 0, fn r, total ->
      total + calculate_region_area(r) * calculate_region_perimeter(r)
    end)
  end

  def calculate_fence_bulk_cost(regions) do
    Enum.reduce(regions, 0, fn r, total ->
      total + calculate_region_area(r) * calculate_region_sides(r)
    end)
  end

  defp calculate_region_sides(region) do
    region
    |> Enum.map(&count_corners(&1, region))
    |> Enum.sum()
  end

  def count_corners({x, y}, region) do
    Enum.count(@corners, fn [{dx1, dy1}, {dx2, dy2}, {dx3, dy3}] ->
      left = {x + dx1, y + dy1}
      diag = {x + dx2, y + dy2}
      front = {x + dx3, y + dy3}

      external_corner? = left not in region and front not in region

      internal_corner? =
        left in region and front in region and diag not in region

      external_corner? or internal_corner?
    end)
  end

  def calculate_region_area(region), do: Enum.count(region)

  def calculate_region_perimeter(region) do
    region
    |> Enum.map(&count_exposed_edges(&1, region))
    |> Enum.sum()
  end

  def count_exposed_edges({x, y}, region) do
    Enum.count(@adjacent4, fn {dx, dy} -> {x + dx, y + dy} not in region end)
  end
end
