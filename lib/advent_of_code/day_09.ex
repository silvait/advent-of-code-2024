defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> parse_disk_bytes()
    |> compress_disk_bytes()
    |> Enum.reverse()
    |> calculate_checksum()
  end

  def parse_disk_bytes(numbers) do
    numbers
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce({0, []}, &parse_map_bytes/2)
    |> elem(1)
    |> Enum.reverse()
  end

  defp parse_map_bytes({count, index}, {id, list}) do
    require Integer

    if Integer.is_even(index) do
      {id + 1, List.duplicate(Integer.to_string(id), count) ++ list}
    else
      {id, List.duplicate(nil, count) ++ list}
    end
  end

  def compress_disk_bytes(disk_map) do
    do_compress_bytes(disk_map, 0, Enum.reverse(disk_map), Enum.count(disk_map) - 1, [])
  end

  defp do_compress_bytes([], _, _, _, compressed), do: compressed

  defp do_compress_bytes(_, start_index, _, end_index, compressed) when start_index > end_index,
    do: compressed

  defp do_compress_bytes(disk_map, start_index, replacements, end_index, compressed) do
    [current | disk_map_rest] = disk_map
    [next | replacement_rest] = replacements

    case [current, next] do
      [nil, nil] ->
        do_compress_bytes(disk_map, start_index, replacement_rest, end_index - 1, compressed)

      [nil, id] ->
        do_compress_bytes(disk_map_rest, start_index + 1, replacement_rest, end_index - 1, [
          id | compressed
        ])

      [id, _] ->
        do_compress_bytes(disk_map_rest, start_index + 1, replacements, end_index, [id | compressed])
    end
  end

  def calculate_checksum(compressed_disk_map) do
    compressed_disk_map
    |> Enum.map(fn x ->
      case x do
        nil -> 0
        _ -> String.to_integer(x)
      end
    end)
    |> Enum.with_index()
    |> Enum.map(&multiply_tuple/1)
    |> Enum.sum()
  end

  defp multiply_tuple({nil, _}), do: 0
  defp multiply_tuple({id, index}), do: id * index

  def expand_files_to_bytes(compressed_files) do
    do_expand(compressed_files, [])
  end

  defp do_expand([], expanded_list), do: expanded_list

  defp do_expand([{ id, count } | rest], expanded_list) do
     do_expand(rest, List.duplicate(id, count) ++ expanded_list)
  end

  def part2(input) do
    input
    |> parse_disk_files()
    |> compress_disk_files()
    |> Enum.reverse()
    |> expand_files_to_bytes()
    |> calculate_checksum()
  end

  def parse_disk_files(numbers) do
    numbers
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce({0, []}, &parse_map_files/2)
    |> elem(1)
    |> Enum.reverse()
  end

  def parse_map_files({count, index}, {id, list}) do
    require Integer

    if Integer.is_even(index) do
      {id + 1, [{Integer.to_string(id), count } | list]}
    else
      {id, [{ nil, count } | list]}
    end
  end

  def compress_disk_files(disk_map) do
    do_compress_files(disk_map, Enum.count(disk_map) - 1)
  end

  def do_compress_files(disk_map, end_index) when end_index < 1, do: disk_map

  def do_compress_files(disk_map, end_index) do
    { highest_id, count } = Enum.at(disk_map, end_index)

    if is_nil(highest_id) do
      do_compress_files(disk_map, end_index - 1)
    else
      case find_free_spot(disk_map, count, end_index) do
        nil ->
          do_compress_files(disk_map, end_index - 1)
        index ->
          {_, free_count} = Enum.at(disk_map, index)

          new_free_count = free_count - count

          if new_free_count > 0 do
            new_disk = List.replace_at(disk_map, end_index, { nil, count })
            |> List.replace_at(index, {highest_id, count})
            |> List.insert_at(index + 1, { nil, new_free_count })

            do_compress_files(new_disk, end_index - 1)
          else
            new_disk = List.replace_at(disk_map, end_index, { nil, count })
            |> List.replace_at(index, {highest_id, count})

            do_compress_files(new_disk, end_index - 1)
          end
      end
    end
  end

  defp find_free_spot(disk_map, count, before_index) do
    Enum.slice(disk_map, 0..before_index-1)
    |> Enum.find_index(fn cell ->
      case cell do
        { nil, free_count } -> free_count >= count
        { _, _ }  -> false
      end
    end)
  end
end
