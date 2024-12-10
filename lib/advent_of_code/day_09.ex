defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> parse_disk_map()
    |> compress_disk_bytes()
    |> Enum.reverse()
    |> calculate_checksum()
  end

  def parse_disk_map(numbers) do
    numbers
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce({0, []}, &parse_map/2)
    |> elem(1)
    |> Enum.reverse()
  end

  defp parse_map({count, index}, {id, list}) do
    require Integer

    if Integer.is_even(index) do
      {id + 1, List.duplicate(Integer.to_string(id), count) ++ list}
    else
      {id, List.duplicate(nil, count) ++ list}
    end
  end

  def compress_disk_files(disk_map) do
    do_compress_files(disk_map, 0, Enum.reverse(disk_map), Enum.count(disk_map) - 1, [])
  end

  defp do_compress_files([], _, _, _, compressed), do: compressed

  defp do_compress_files(_disk_map, _start_index, _replacements, _end_index, _compressed) do
    ["42","42"]
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
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_disk_map()
    |> compress_disk_files()
    |> Enum.reverse()
    |> calculate_checksum()
  end
end
