defmodule AdventOfCode.Day14 do
  @moduledoc false

  def part1(input, dimensions) do
    input
    |> parse_input()
    |> simulate(dimensions)
    |> count_robots_per_quadrant(dimensions)
    |> Enum.product()
  end

  def part2(input, dimensions) do
    input
    |> parse_input()
    |> simulate_and_check(dimensions)
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_robot/1)
  end

  def parse_robot(line) do
    ["p=" <> start, "v=" <> velocity] = String.split(line)

    start = parse_coordinates(start)
    velocity = parse_coordinates(velocity)

    {start, velocity}
  end

  def parse_coordinates(coordinates) do
    coordinates
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def simulate(bots, dimensions) do
    Enum.reduce(1..10_000, bots, fn _step, space ->
      Enum.map(space, &move_bot(&1, dimensions))
    end)
  end

  def simulate_and_check(bots, dimensions) do
    total_bots = Enum.count(bots)

    Enum.reduce_while(1..10_000, bots, fn step, space ->
      new_bots = Enum.map(space, &move_bot(&1, dimensions))
      coordinates = for {location, _v} <- new_bots, do: location

      if Enum.count(Enum.uniq(coordinates)) == total_bots do
        {:halt, step}
      else
        {:cont, new_bots}
      end
    end)
  end

  def move_bot({{x, y}, {dx, dy}}, {width, height}) do
    new_x = wrap_add(x, dx, 0, width)
    new_y = wrap_add(y, dy, 0, height)

    {{new_x, new_y}, {dx, dy}}
  end

  def wrap_add(n, inc, min, max) do
    new_n = n + inc

    cond do
      new_n < min -> new_n + max
      new_n >= max -> new_n - max
      true -> new_n
    end
  end

  def count_robots_per_quadrant(bots, dimensions) do
    bots
    |> split_by_quadrant(dimensions)
    |> Enum.map(fn {_k, v} -> Enum.count(v) end)
  end

  def split_by_quadrant(bots, {width, height}) do
    q1_x_range = 0..(div(width, 2) - 1)
    q1_y_range = 0..(div(height, 2) - 1)

    q2_x_range = round(width / 2)..(width - 1)
    q2_y_range = 0..(div(height, 2) - 1)

    q3_x_range = 0..(div(width, 2) - 1)
    q3_y_range = round(height / 2)..(height - 1)

    q4_x_range = round(width / 2)..(width - 1)
    q4_y_range = round(height / 2)..(height - 1)

    Enum.group_by(bots, fn {{x, y}, _} ->
      cond do
        x in q1_x_range and y in q1_y_range -> :q1
        x in q2_x_range and y in q2_y_range -> :q2
        x in q3_x_range and y in q3_y_range -> :q3
        x in q4_x_range and y in q4_y_range -> :q4
        true -> :none
      end
    end)
    |> Map.delete(:none)
  end
end
