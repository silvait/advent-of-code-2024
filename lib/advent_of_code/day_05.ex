defmodule AdventOfCode.Day05 do
  def part1(input_file) do
    input_file
    |> read_file()
    |> parse_input()
    |> process_updates()
  end

  defp read_file(input_file) do
    input_file
    |> File.read!()
    |> String.split("\n")
  end

  defp parse_input(lines) do
    Enum.reduce(lines, {%{}, []}, fn l, {rules, updates} ->
      cond do
        String.contains?(l, "|") ->
          new_rules = add_rule(l, rules)
          {new_rules, updates}

        String.contains?(l, ",") ->
          new_updates = add_update(l, updates)
          {rules, new_updates}

        true ->
          {rules, updates}
      end
    end)
  end

  defp add_rule(line, rules) do
    [key, num] = String.split(line, "|") |> Enum.map(&String.to_integer/1)

    {_, new_rules} = Map.get_and_update(rules, key, fn current_value ->
      new_value = case current_value do
        nil -> [num]
        current_value -> [num | current_value]
      end

      {current_value, new_value}
    end)

    new_rules
  end

  defp add_update(line, updates) do
    new_update = String.split(line, ",") |> Enum.map(&String.to_integer/1)
    [new_update | updates]
  end

  defp valid_update?(update, rules) do
    check_rules(update, rules, MapSet.new())
  end

  defp check_rules([], _, _), do: true

  defp check_rules([num | rest], rules, seen) do
    num_rules = Map.get(rules, num, [])

    if Enum.any?(num_rules, &MapSet.member?(seen, &1)) do
      false
    else
      check_rules(rest, rules, MapSet.put(seen, num))
    end
  end

  defp get_middle_element(list) do
    middle_index = length(list) |> div(2)
    Enum.at(list, middle_index)
  end

  defp process_updates({ rules, updates }) do
    updates
    |> Enum.filter(&valid_update?(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.sum()
  end

  defp find_num_index([], _), do: -1
  defp find_num_index(_, []), do: 0

  defp find_num_index(num_rule, update) do
    Enum.map(num_rule, fn x ->
      Enum.find_index(update, &(&1 == x))
    end)
    |> Enum.sort()
    |> hd() || -1
  end

  defp fix_bad_update(bad_update, rules) do
    create_new_update(bad_update, rules, [])
  end

  defp create_new_update([], _, new_update), do: new_update

  defp create_new_update([num | rest], rules, new_update) do
    num_rules = Map.get(rules, num, [])
    index = find_num_index(num_rules, new_update)
    create_new_update(rest, rules, List.insert_at(new_update, index, num))
  end

  defp process_bad_updates({ rules, updates }) do
    updates
    |> Enum.reject(&valid_update?(&1, rules))
    |> Enum.map(&fix_bad_update(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.sum()
  end

  def part2(input_file) do
    input_file
    |> read_file()
    |> parse_input()
    |> process_bad_updates()
  end
end
