defmodule Frequency do
  def calculate(frequency_changes_string) do
    string_to_integer_list(frequency_changes_string)
    |> add_frequency_changes(0)
  end

  def first_repeated_frequency(frequency_changes_string) do
    string_to_integer_list(frequency_changes_string)
    |> find_repeated_frequency(MapSet.new([0]), 0)
  end

  # defp find_repeated_frequency(_, [head | tail]) when Enum.member?(tail, head) do
  #   head
  # end

  defp find_repeated_frequency([head | tail], frequencies, previous_frequency) do
    new_frequency = previous_frequency + head
    if MapSet.member?(frequencies, new_frequency) do
    # if Enum.member?(frequencies, new_frequency) do
      new_frequency
    else
      find_repeated_frequency((tail ++ [head]), MapSet.put(frequencies, new_frequency), new_frequency)
    end
  end

  defp add_frequency_changes([], sum) do
    sum
  end

  defp add_frequency_changes([head | tail], sum) do
    add_frequency_changes(tail, sum + head)
  end

  defp string_to_integer_list(str) do
    str
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
  end
end