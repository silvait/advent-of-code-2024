defmodule AdventOfCode.Day11 do
  require Integer

  def part1(input) do
    solve(input, 25)
  end

  def part2(input) do
    solve(input, 40)
  end

  defp solve(input, times) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> blink(times)
    |> Enum.count()
  end

  defp blink(numbers, times) do
    rule_cache = %{}

    Enum.reduce(1..times, {numbers, rule_cache}, fn _, {result, cache} ->
      do_blink(result, cache, [])
    end)
    |> elem(0)
  end

  defp do_blink([], cache, result), do: {result, cache}

  defp do_blink([n | rest], cache, result) do
    {current_result, new_cache} = apply_rule(n, cache)
    do_blink(rest, new_cache, current_result ++ result)
  end

  defp apply_rule(num, cache) do
    case Map.get(cache, num) do
      nil ->
        result =
          cond do
            num == 0 -> [1]
            number_of_digits(num) |>  Integer.is_even() -> split_number(num)
            true -> [num * 2024]
          end

        new_cache = Map.put(cache, num, result)
        {result, new_cache}

      cached_result ->
        {cached_result, cache}
    end
  end

  defp number_of_digits(num) do
    Integer.digits(num) |> Enum.count()
  end

  defp split_number(num) do
    num_digits = number_of_digits(num)
    half_digits = div(num_digits, 2)

    left = div(num, :math.pow(10, num_digits - half_digits) |> round)
    right = rem(num, :math.pow(10, num_digits - half_digits) |> round)

    [left, right]
  end
end
