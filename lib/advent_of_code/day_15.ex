defmodule AdventOfCode.Day15 do
  @moduledoc false

  @wall "#"
  @space "."
  @start "@"
  @box "O"

  @left "<"
  @right ">"
  @up "^"
  @down "v"

  def part1(input_file), do: solve(input_file, &parse_input/1)

  def part2(input_file), do: solve(input_file, &parse_wide_input/1)

  defp solve(input_file, parse_fun) do
    input_file
    |> File.read!()
    |> parse_fun.()
    |> run_simulation()
    |> calculate_box_gps()
    |> Enum.sum()
  end

  defp parse_input(input) do
    [map_input, moves_input] = String.split(input, "\n\n")
    {parse_map(map_input), parse_moves(moves_input)}
  end

  defp parse_wide_input(input) do
    [map_input, moves_input] = String.split(input, "\n\n")
    {parse_map(map_input), parse_moves(moves_input)}
  end

  defp parse_map(map_input) do
    map_input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(&parse_map_line/1)
    |> Map.new()
  end

  defp parse_map_line({map_line, y}) do
    map_line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {tile, x} -> {{x, y}, tile} end)
  end

  defp parse_moves(moves_input) do
    moves_input
    |> String.split("\n")
    |> Enum.flat_map(&String.graphemes/1)
  end

  def run_simulation({map, moves}) do
    start_position = find_start_position(map)

    Enum.reduce(moves, {map, start_position}, fn direction, {map, position} ->
      next_position = move(position, direction)

      case Map.get(map, next_position) do
        @wall -> {map, position}
        tile when tile in [@start, @space] -> {map, next_position}
        @box -> push_box(map, next_position, direction)
      end
    end)
    |> elem(0)
  end

  defp find_start_position(map) do
    Enum.find(map, fn {_k, v} -> v == @start end) |> elem(0)
  end

  def move({x, y}, @up), do: {x, y - 1}
  def move({x, y}, @right), do: {x + 1, y}
  def move({x, y}, @down), do: {x, y + 1}
  def move({x, y}, @left), do: {x - 1, y}

  def move_back(position, @up), do: move(position, @down)
  def move_back(position, @right), do: move(position, @left)
  def move_back(position, @down), do: move(position, @up)
  def move_back(position, @left), do: move(position, @right)

  def push_box(map, box_position, direction) do
    next_position = move(box_position, direction)
    next_tile = Map.get(map, next_position)

    case next_tile do
      @wall ->
        {map, move_back(box_position, direction)}

      tile when tile in [@start, @space] ->
        {
          Map.put(map, box_position, @space) |> Map.put(next_position, @box),
          box_position
        }

      @box ->
        {new_map, new_position} = push_box(map, next_position, direction)

        # Next box can not move
        if new_position == box_position do
          {new_map, move_back(box_position, direction)}
        else
          {
            Map.put(new_map, box_position, @space) |> Map.put(next_position, @box),
            box_position
          }
        end
    end
  end

  def calculate_box_gps(map) do
    for {{x, y}, tile} <- map, tile == @box, do: x + 100 * y
  end
end
