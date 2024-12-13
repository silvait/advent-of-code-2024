defmodule AdventOfCode.Day09 do
  @moduledoc false

  @free_space -1

  require Integer

  def part1(input) do
    input
    |> parse_disk_blocks()
    |> compress_disk_blocks()
    |> calculate_checksum()
  end

  def parse_disk_blocks(line) do
    line
    |> parse_numbers()
    |> process_disk_blocks()
  end

  defp parse_numbers(line) do
    line |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  defp process_disk_blocks(numbers) do
    numbers
    |> parse_map_bytes(0, [])
    |> Enum.reverse()
  end

  defp parse_map_bytes([], _, list), do: list

  defp parse_map_bytes([count | rest], index, list) when Integer.is_even(index) do
    file_id = div(index, 2)
    block = List.duplicate(file_id, count)
    parse_map_bytes(rest, index + 1, block ++ list)
  end

  defp parse_map_bytes([count | rest], index, list) do
    block = List.duplicate(@free_space, count)
    parse_map_bytes(rest, index + 1, block ++ list)
  end

  def compress_disk_blocks(disk) do
    do_compress_bytes(disk, 0, Enum.reverse(disk), Enum.count(disk) - 1, [])
    |> Enum.reverse()
  end

  defp do_compress_bytes([], _, _, _, compressed), do: compressed

  defp do_compress_bytes(_, start_i, _, end_i, compressed) when start_i > end_i,
    do: compressed

  defp do_compress_bytes(disk, start_i, replacements, end_i, compressed) do
    [current | disk_rest] = disk
    [next | replacement_rest] = replacements

    case [current, next] do
      [@free_space, @free_space] ->
        do_compress_bytes(disk, start_i, replacement_rest, end_i - 1, compressed)

      [@free_space, id] ->
        do_compress_bytes(disk_rest, start_i + 1, replacement_rest, end_i - 1, [id | compressed])

      [id, _] ->
        do_compress_bytes(disk_rest, start_i + 1, replacements, end_i, [id | compressed])
    end
  end

  def calculate_checksum(disk) do
    disk
    |> Enum.with_index()
    |> Enum.reduce(0, fn {x, index}, sum ->
      case x do
        @free_space -> sum
        _ -> sum + x * index
      end
    end)
  end

  def expand_files_to_bytes(compressed_files) do
    do_expand(compressed_files, [])
  end

  defp do_expand([], expanded_list), do: expanded_list

  defp do_expand([{id, count} | rest], expanded_list) do
    do_expand(rest, List.duplicate(id, count) ++ expanded_list)
  end

  def part2(input) do
    input
    |> parse_disk_files()
    |> compress_disk_files()
    |> expand_files_to_bytes()
    |> calculate_checksum()
  end

  def parse_disk_files(line) do
    line
    |> parse_numbers()
    |> Enum.with_index()
    |> Enum.reduce([], &parse_map_files/2)
    |> Enum.reverse()
  end

  def parse_map_files({count, index}, list) do
    if Integer.is_even(index) do
      id = div(index, 2)
      [{id, count} | list]
    else
      [{@free_space, count} | list]
    end
  end

  def compress_disk_files(disk) do
    do_compress_files(disk, Enum.count(disk) - 1) |> Enum.reverse()
  end

  def do_compress_files(disk, end_i) when end_i < 1, do: disk

  def do_compress_files(disk, end_i) do
    {highest_id, count} = Enum.at(disk, end_i)

    if highest_id == @free_space do
      do_compress_files(disk, end_i - 1)
    else
      case find_free_spot(disk, count, end_i) do
        nil -> do_compress_files(disk, end_i - 1)
        index -> move_file_to_free_space(disk, end_i, index)
      end
    end
  end

  defp move_file_to_free_space(disk, file_index, free_index) do
    {highest_id, count} = Enum.at(disk, file_index)

    {_, free_count} = Enum.at(disk, free_index)
    new_free_count = free_count - count

    if new_free_count > 0 do
      new_disk =
        List.replace_at(disk, file_index, {@free_space, count})
        |> List.replace_at(free_index, {highest_id, count})
        |> List.insert_at(free_index + 1, {@free_space, new_free_count})

      do_compress_files(new_disk, file_index - 1)
    else
      new_disk =
        List.replace_at(disk, file_index, {@free_space, count})
        |> List.replace_at(free_index, {highest_id, count})

      do_compress_files(new_disk, file_index - 1)
    end
  end

  defp find_free_spot(disk, count, before_index) do
    Enum.slice(disk, 0..(before_index - 1))
    |> Enum.find_index(fn cell ->
      case cell do
        {@free_space, free_count} -> free_count >= count
        {_, _} -> false
      end
    end)
  end
end
