defmodule PolymerThingy do
  def final_length(polymer) do
    polymer
    |> String.graphemes
    |> reduce_polymer(0)
    |> Enum.count
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