defmodule AdventOfCode.Day10 do
  @north {0, -1}
  @east {1, 0}
  @south {0, 1}
  @west {-1, 0}

  @directions [@north, @east, @south, @west]

  def part1(input_file), do: solve(input_file, &score_trailheads/1)

  def part2(input_file), do: solve(input_file, &find_trails/1)

  def solve(input_file, fun) do
    input_file
    |> read_lines()
    |> parse_number_grid()
    |> fun.()
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp read_lines(input_file), do: File.read!(input_file) |> String.split("\n", trim: true)

  defp parse_number_grid(lines) do
    lines
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
    |> Map.new()
  end

  defp parse_line({line, y}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {height, x} -> {{x, y}, String.to_integer(height)} end)
  end

  defp find_trails(grid), do: find_trailheads(grid) |> Enum.map(&walk_grid(grid, &1, 0))

  defp score_trailheads(grid), do: find_trails(grid) |> Enum.map(&Enum.uniq/1)

  defp move({x, y}, {delta_x, delta_y}), do: {x + delta_x, y + delta_y}

  defp find_trailheads(grid) do
    for {k, v} <- grid, v == 0, do: k
  end

  defp walk_grid(grid, location, step) do
    case {Map.get(grid, location), step} do
      # outside grid
      {nil, _} -> []
      # end of trail
      {9, 9} -> [location]
      # next step
      {a, a} -> Enum.flat_map(@directions, &walk_grid(grid, move(location, &1), step + 1))
      # wrong way
      {_, _} -> []
    end
  end
end
