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
    result = figure_count_maps(box_id)

    counts = if Enum.member?(Map.values(result), 2) do
      Map.update(counts, "two_count", counts["two_count"], &(&1 + 1))
    else
      counts
    end

    counts = if Enum.member?(Map.values(result), 3) do
      Map.update(counts, "three_count", counts["three_count"], &(&1 + 1))
    else
      counts
    end
    calculate_checksum(remaining_box_ids, counts)
  end

  # Return e.g., {"2_count": 3, "3_count": 2}
  defp figure_count_maps(box_id) do
    Enum.reduce String.graphemes(box_id), %{}, fn(letter, acc) ->
      Map.update(acc, letter, 1, &(&1 + 1))
    end
  end
end