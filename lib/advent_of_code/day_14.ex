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
    ["p=" <> position, "v=" <> velocity] = String.split(line)

    position = parse_coordinates(position)
    velocity = parse_coordinates(velocity)

    {position, velocity}
  end

  def parse_coordinates(coordinates) do
    coordinates
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def simulate(bots, dimensions) do
    Enum.reduce(1..100, bots, fn _step, space ->
      Enum.map(space, &move_bot(&1, dimensions))
    end)
  end

  def simulate_and_check(bots, dimensions) do
    total_bots = Enum.count(bots)

    Enum.reduce_while(1..10_000, bots, fn step, bots ->
      new_bots = Enum.map(bots, &move_bot(&1, dimensions))

      unique_coordinates =
        new_bots
        |> Enum.map(&elem(&1, 0))
        |> Enum.uniq()
        |> Enum.count()

      if unique_coordinates == total_bots do
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

  def wrap_add(n, inc, min, max), do: maybe_wrap(n + inc, min, max)

  def maybe_wrap(n, min, max) when n < min, do: n + max
  def maybe_wrap(n, _min, max) when n >= max, do: n - max
  def maybe_wrap(n, _min, _max), do: n

  def count_robots_per_quadrant(bots, {width, height}) do
    q1 = {0..(div(width, 2) - 1), 0..(div(height, 2) - 1)}
    q2 = {round(width / 2)..(width - 1), 0..(div(height, 2) - 1)}
    q3 = {0..(div(width, 2) - 1), round(height / 2)..(height - 1)}
    q4 = {round(width / 2)..(width - 1), round(height / 2)..(height - 1)}

    Enum.frequencies_by(bots, fn {position, _} ->
      cond do
        in_quadrant?(position, q1) -> :q1
        in_quadrant?(position, q2) -> :q2
        in_quadrant?(position, q3) -> :q3
        in_quadrant?(position, q4) -> :q4
        true -> :middle
      end
    end)
    |> Map.delete(:middle)
    |> Enum.map(&elem(&1, 1))
  end

  def in_quadrant?({x, y}, {quadrant_x_range, quadrant_y_range}) do
    x in quadrant_x_range and y in quadrant_y_range
  end
end
