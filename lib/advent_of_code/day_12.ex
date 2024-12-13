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

  def part1(input_file), do: solve(input_file, &calculate_fence_cost/1)

  def part2(input_file), do: solve(input_file, &calculate_bulk_fence_cost/1)

  defp solve(input_file, calculate_fence_cost_fn) do
    input_file
    |> read_lines()
    |> parse_grid()
    |> parse_regions()
    |> calculate_fence_cost_fn.()
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

  defp parse_regions(grid) do
    Map.keys(grid)
    |> Enum.reduce({[], MapSet.new()}, fn location, {regions, seen} ->
      if location in seen do
        {regions, seen}
      else
        new_region = find_region(grid, location)
        {[new_region | regions], MapSet.union(seen, new_region)}
      end
    end)
    |> elem(0)
  end

  defp move({x, y}, {dx, dy}), do: {x + dx, y + dy}

  defp find_region(grid, location, region \\ MapSet.new()) do
    if location in region do
      region
    else
      region = MapSet.put(region, location)
      label = Map.get(grid, location)

      @adjacent4
      |> Enum.map(&move(location, &1))
      |> Enum.reject(&(Map.get(grid, &1) != label))
      |> Enum.reduce(region, fn next_location, region ->
        find_region(grid, next_location, region)
      end)
    end
  end

  def calculate_fence_cost(regions) do
    regions
    |> Enum.map(&(calculate_region_area(&1) * calculate_region_perimeter(&1)))
    |> Enum.sum()
  end

  def calculate_bulk_fence_cost(regions) do
    regions
    |> Enum.map(&(calculate_region_area(&1) * calculate_region_sides(&1)))
    |> Enum.sum()
  end

  def calculate_region_area(region), do: Enum.count(region)

  def calculate_region_perimeter(region) do
    region
    |> Enum.map(&count_exposed_edges(&1, region))
    |> Enum.sum()
  end

  def count_exposed_edges(location, region) do
    Enum.count(@adjacent4, &(move(location, &1) not in region))
  end

  defp calculate_region_sides(region) do
    region
    |> Enum.map(&count_corners(&1, region))
    |> Enum.sum()
  end

  def count_corners(location, region) do
    Enum.count(@corners, fn [left_direction, diag_direction, foward_direction] ->
      left = move(location, left_direction)
      diag = move(location, diag_direction)
      front = move(location, foward_direction)

      external_corner? = left not in region and front not in region
      internal_corner? = left in region and front in region and diag not in region

      external_corner? or internal_corner?
    end)
  end
end
