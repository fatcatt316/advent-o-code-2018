defmodule BoxScanner do
  def checksum(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> calculate_checksum(%{"three_count" => 0, "two_count" => 0})
  end

  defp calculate_checksum([], counts) do
    counts["two_count"] * counts["three_count"]
  end

  defp calculate_checksum([box_id | remaining_box_ids], counts) do
    result = character_counts(box_id)

    counts = counts
    |> update_counts(result, "two_count", 2)
    |> update_counts(result, "three_count", 3)

    calculate_checksum(remaining_box_ids, counts)
  end

  defp update_counts(counts, result, key, digit) do
    if Enum.member?(Map.values(result), digit) do
      Map.update(counts, key, counts[key], &(&1 + 1))
    else
      counts
    end
  end

  defp character_counts(box_id) do
    Enum.reduce String.graphemes(box_id), %{}, fn(letter, acc) ->
      Map.update(acc, letter, 1, &(&1 + 1))
    end
  end
end