defmodule AdventOfCode.Day15 do
  @moduledoc false

  @wall "#"
  @space "."
  @start "@"
  @box "O"
  @box_left "["
  @box_right "]"

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
    input |> expand_map() |> parse_input()
  end

  defp expand_map(map_input) do
    map_input
    |> String.replace(@wall, @wall <> @wall)
    |> String.replace(@box, @box_left <> @box_right)
    |> String.replace(@space, @space <> @space)
    |> String.replace(@start, @start <> @space)
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
      process_next_step(map, position, direction)
    end)
    |> elem(0)
  end

  def process_next_step(map, position, direction) do
    next_position = move(position, direction)

    case Map.get(map, next_position) do
      @wall ->
        {map, position}

      tile when tile in [@start, @space] ->
        move_bot(map, position, direction)

      tile when tile in [@box, @box_left, @box_right] ->
        if can_push_box?(map, next_position, direction) do
          push_box(map, next_position, direction, tile) |> move_bot(position, direction)
        else
          {map, position}
        end
    end
  end

  defp move_bot(map, position, direction) do
    next_position = move(position, direction)

    {
      map |> Map.put(position, @space) |> Map.put(next_position, @start),
      next_position
    }
  end

  defp find_start_position(map) do
    Enum.find(map, fn {_k, v} -> v == @start end) |> elem(0)
  end

  def move({x, y}, @up), do: {x, y - 1}
  def move({x, y}, @right), do: {x + 1, y}
  def move({x, y}, @down), do: {x, y + 1}
  def move({x, y}, @left), do: {x - 1, y}

  def can_push_box?(map, current_position, direction) do
    next_position = move(current_position, direction)

    case Map.get(map, current_position) do
      @wall ->
        false

      tile when tile in [@space, @start] ->
        true

      tile when tile in [@box_left, @box_right] and direction in [@up, @down] ->
        can_push_box?(map, next_position, direction) and
          can_push_box?(map, move(next_position, pair_direction(tile)), direction)

      tile when tile in [@box, @box_left, @box_right] ->
        can_push_box?(map, next_position, direction)
    end
  end

  defp pair_direction(@box_left), do: @right
  defp pair_direction(@box_right), do: @left

  def push_box(map, current_position, direction, current_tile) do
    next_position = move(current_position, direction)
    next_tile = Map.get(map, next_position)

    case current_tile do
      tile when tile in [@space, @start, @wall] ->
        map

      tile when tile in [@box_left, @box_right] and direction in [@up, @down] ->
        pair_position = move(current_position, pair_direction(current_tile))
        pair_tile = Map.get(map, pair_position)

        map
        |> push_box(next_position, direction, next_tile)
        |> Map.put(current_position, @space)
        |> Map.put(next_position, current_tile)
        |> push_box(pair_position, direction, pair_tile)

      tile when tile in [@box, @box_left, @box_right] ->
        map
        |> push_box(next_position, direction, next_tile)
        |> Map.put(current_position, @space)
        |> Map.put(next_position, current_tile)
    end
  end

  def calculate_box_gps(map) do
    for {{x, y}, tile} <- map, tile in [@box, @box_left], do: x + 100 * y
  end
end
