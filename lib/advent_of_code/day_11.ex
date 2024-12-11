defmodule AdventOfCode.Day11 do
  require Integer

  def part1(input) do
    solve(input, 25)
  end

  def part2(input) do
    solve(input, 38)
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
            Integer.digits(num) |> Enum.count() |> Integer.is_even() -> split_number(num)
            true -> [num * 2024]
          end

        new_cache = Map.put(cache, num, result)
        {result, new_cache}

      cached_result ->
        {cached_result, cache}
    end
  end

  defp split_number(num) do
    num_str = Integer.to_string(num)
    count = String.length(num_str)
    middle = div(count, 2)

    [String.slice(num_str, 0, middle), String.slice(num_str, middle, count)]
    |> Enum.map(&String.to_integer/1)
  end
end
