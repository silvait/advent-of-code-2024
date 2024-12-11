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

  defp parse_line_numbers(line), do: line |> String.split() |> Enum.map(&String.to_integer/1)

  def blink(stones, max_blinks) do
    Enum.map(stones, &(do_blink(&1, max_blinks, 1, %{}) |> elem(0)))
  end

  def do_blink(_, max_blinks, blinks, cache) when blinks > max_blinks, do: {1, cache}

  def do_blink(num, max_blinks, blinks, cache) do
    cache_key = {num, blinks}

    {result, new_cache} =
      case Map.get(cache, cache_key) do
        nil ->
          cond do
            num == 0 ->
              do_blink(1, max_blinks, blinks + 1, cache)

            even_number_of_digits?(num) ->
              [left, right] = bisect_number(num)

              {result_a, new_cache_a} = do_blink(left, max_blinks, blinks + 1, cache)
              {result_b, new_cache_b} = do_blink(right, max_blinks, blinks + 1, new_cache_a)

              {result_a + result_b, new_cache_b}

            true ->
              do_blink(num * 2024, max_blinks, blinks + 1, cache)
          end

        value ->
          {value, cache}
      end

    {result, Map.put(new_cache, cache_key, result)}
  end

  defp even_number_of_digits?(num), do: number_of_digits(num) |> Integer.is_even()

  defp number_of_digits(num), do: Integer.digits(num) |> Enum.count()

  defp bisect_number(num) do
    middle_index = number_of_digits(num) |> div(2)
    divisor = :math.pow(10, middle_index) |> round

    [div(num, divisor), rem(num, divisor)]
  end
end
