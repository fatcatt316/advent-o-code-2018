defmodule PolymerThingy do
  def final_length(polymer) do
    polymer
    |> String.graphemes
    |> reduce_polymer(0)
    |> Enum.count
  end

  def removed_length(polymer, removal_letter) do
    polymer
    |> String.split(~r/#{removal_letter}/i, trim: true)
    |> Enum.join
    |> final_length
  end

  def shortest_polymer_length(polymer) do
    cycle_removal_letters(
      polymer,
      letters_to_try(polymer),
      String.length(polymer)
    )
  end

  def cycle_removal_letters(_, [], shortest_length) do
    shortest_length
  end

  def cycle_removal_letters(polymer, [removal_letter | remaining_letters], shortest_length) do
    cycle_removal_letters(
      polymer,
      remaining_letters,
      min(shortest_length, removed_length(polymer, removal_letter))
    )
  end

  defp letters_to_try(polymer) do
    polymer
    |> String.downcase
    |> String.graphemes
    |> MapSet.new
    |> MapSet.to_list
  end

  defp reduce_polymer(units, idx) do
    cond do
      idx+1 >= Enum.count(units) ->
        units
      units_should_destroy(Enum.at(units, idx), Enum.at(units, idx+1)) ->
        units
        |> List.delete_at(idx)
        |> List.delete_at(idx)
        |> reduce_polymer(max(idx-1, 0))
      true ->
        reduce_polymer(units, idx+1)
    end
  end

  defp units_should_destroy(char1, char2) do
    char1 != char2 and String.downcase(char1) == String.downcase(char2)
  end
end