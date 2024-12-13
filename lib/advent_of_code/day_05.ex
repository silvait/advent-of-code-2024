defmodule AdventOfCode.Day05 do
  @moduledoc false

  def part1(input_file) do
    input_file
    |> read_file()
    |> parse_input()
    |> process_updates()
  end

  defp read_file(input_file) do
    input_file
    |> File.read!()
  end

  defp tuples_to_map_of_lists(tuples) do
    Enum.reduce(tuples, %{}, fn {key, value}, acc ->
      Map.update(acc, key, [value], fn existing_values -> [value | existing_values] end)
    end)
  end

  defp parse_number_pair(line) do
    line
    |> String.split("|")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp parse_rules(rules_section) do
    rules_section
    |> String.split("\n")
    |> Enum.map(&parse_number_pair/1)
    |> tuples_to_map_of_lists()
  end

  defp parse_number_list(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  defp parse_updates(updates_section) do
    updates_section
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_number_list/1)
  end

  defp parse_input(lines) do
    [rules_section, updates_section] = String.split(lines, "\n\n")
    {parse_rules(rules_section), parse_updates(updates_section)}
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

  defp process_updates({rules, updates}) do
    updates
    |> Enum.filter(&valid_update?(&1, rules))
    |> Enum.map(&get_middle_element/1)
    |> Enum.sum()
  end

  defp find_num_index(num_rule, update) do
    Enum.find_index(update, &Enum.member?(num_rule, &1)) || -1
  end

  defp fix_bad_update(bad_update, rules) do
    Enum.reduce(bad_update, [], fn num, new_update ->
      num_rules = Map.get(rules, num, [])
      index = find_num_index(num_rules, new_update)

      List.insert_at(new_update, index, num)
    end)
  end

  defp process_bad_updates({rules, updates}) do
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
