defmodule AdventOfCode.Day11 do
  require Integer

  def part1(input), do: solve(input, 25)

  def part2(input), do: solve(input, 75)

  defp solve(input, times) do
    input
    |> parse_line_numbers()
    |> blink(times)
    |> Enum.sum()
  end

  defp parse_line_numbers(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def blink(stones, n) do
    Enum.map(stones, &(do_blink(&1, n, %{}) |> elem(0)))
  end

  def do_blink(_, 0, cache), do: {1, cache}

  def do_blink(num, n, cache) do
    cache_key = {num, n}
    cached_result = Map.get(cache, cache_key)

    if cached_result == nil do
      {result, new_cache} =
        case apply_rule(num) do
          [a, b] ->
            {result_a, cache_a} = do_blink(a, n - 1, cache)
            {result_b, cache_b} = do_blink(b, n - 1, cache_a)
            {result_a + result_b, cache_b}

          a ->
            do_blink(a, n - 1, cache)
        end

      {result, Map.put(new_cache, cache_key, result)}
    else
      {cached_result, cache}
    end
  end

  defp apply_rule(0), do: 1

  defp apply_rule(num) do
    if even_number_of_digits?(num) do
      bisect_number(num)
    else
      num * 2024
    end
  end

  defp even_number_of_digits?(num), do: number_of_digits(num) |> Integer.is_even()

  defp number_of_digits(num), do: Integer.digits(num) |> Enum.count()

  defp bisect_number(num) do
    middle_index = number_of_digits(num) |> div(2)
    divisor = :math.pow(10, middle_index) |> trunc

    [div(num, divisor), rem(num, divisor)]
  end
end
