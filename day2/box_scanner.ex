defmodule BoxScanner do
  def common_letters(file_path) do
    box_ids = File.read!(file_path)
    |> String.split("\n")

    box_id = List.first(box_ids)
    other_box_ids = List.delete_at(box_ids, 0)

    find_almost_equal_box_ids(
      box_id,
      other_box_ids,
      other_box_ids
    )
  end

  defp find_almost_equal_box_ids(_current_box_id, [], unchecked_box_ids) do
    box_id = List.first(unchecked_box_ids)
    other_box_ids = List.delete_at(unchecked_box_ids, 0)

    find_almost_equal_box_ids(box_id, other_box_ids, other_box_ids)
  end

  defp find_almost_equal_box_ids(current_box_id, other_box_ids, unchecked_box_ids) do
    diff_idxs = different_indices(
      String.graphemes(current_box_id),
      String.graphemes(Enum.at(other_box_ids, 0)),
      [],
      0
    )

    if Enum.count(diff_idxs) == 1 do
      String.graphemes(current_box_id)
      |> List.delete_at(Enum.at(diff_idxs, 0))
      |> Enum.join
    else
      find_almost_equal_box_ids(
        current_box_id,
        List.delete_at(other_box_ids, 0),
        unchecked_box_ids
      )
    end
  end

  defp different_indices([], [], indices, _idx) do
    indices
  end

  defp different_indices([id1_char | id1_chars], [id2_char | id2_chars], indices, idx) when id1_char == id2_char do
    different_indices(id1_chars, id2_chars, indices, idx + 1)
  end

  defp different_indices([id1_char | id1_chars], [id2_char | id2_chars], indices, idx) when id1_char != id2_char do
    different_indices(id1_chars, id2_chars, indices ++ [idx], idx + 1)
  end

  ######## PART 1 BELOW ########

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