defmodule AdventOfCode.Day11 do
  @moduledoc false

  require Integer

  def part1(input), do: solve(input, 25)

  def part2(input), do: solve(input, 75)

  defp solve(input, times) do
    input
    |> parse_line_numbers()
    |> blink(times)
  end

  defp parse_line_numbers(line) do
    String.split(line) |> Enum.map(&String.to_integer/1)
  end

  def blink(stones, n) do
    Enum.reduce(stones, {0, %{}}, fn number, {total, cache} ->
      {count, updated_cache} = do_blink(number, n, cache)
      {total + count, updated_cache}
    end)
    |> elem(0)
  end

  def do_blink(_, 0, cache), do: {1, cache}

  def do_blink(number, n, cache) do
    cache_key = {number, n}
    cached_result = Map.get(cache, cache_key)

    if cached_result == nil do
      {result, updated_cache} =
        case apply_rule(number) do
          [a, b] ->
            {result_a, cache_a} = do_blink(a, n - 1, cache)
            {result_b, cache_b} = do_blink(b, n - 1, cache_a)
            {result_a + result_b, cache_b}

          a ->
            do_blink(a, n - 1, cache)
        end

      {result, Map.put(updated_cache, cache_key, result)}
    else
      {cached_result, cache}
    end
  end

  defp apply_rule(0), do: 1

  defp apply_rule(number) do
    if even_number_of_digits?(number) do
      bisect_number(number)
    else
      number * 2024
    end
  end

  defp even_number_of_digits?(number) do
    number_of_digits(number) |> Integer.is_even()
  end

  defp number_of_digits(number) do
    Integer.digits(number) |> Enum.count()
  end

  defp bisect_number(number) do
    middle_index = number_of_digits(number) |> div(2)
    divisor = :math.pow(10, middle_index) |> trunc

    [div(number, divisor), rem(number, divisor)]
  end
end
