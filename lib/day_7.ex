defmodule AdventElixir.Day7 do
  @moduledoc ~S"""
  Day 7

  ## Examples

      iex> part1()
      110

  """

  import AdventElixir.Input, only: [day7: 0]
  import AdventElixir.Util

  def part1 do
    day7()
    |> prepare_input()
    |> Enum.count(fn %{snet: snet, hnet: hnet} ->
      Enum.any?(snet, &contains_abba/1) && Enum.all?(hnet, &(not contains_abba(&1))) end)
  end

  def part2 do
    day7()
    |> prepare_input()
    |> Enum.count(&contains_aba_bab/1)
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> create_ip7_map()))
  end

  defp create_ip7_map(line) do
    split = ~r/(?<=\w)(?=\[)|(?<=\])(?=\w)/
    line
    |> String.split(split)
    |> Enum.group_by(fn s -> String.at(s, 0) == "[" end) # :false == supernet, :true == hypernet
    |> (fn %{false: snet, true: hnet} ->
        %{snet: snet, hnet: Enum.map(hnet, &String.replace(&1, ~r/\[|\]/, ""))} end).()
  end

  defp contains_abba(sequence) do
    abba = ~r/(.)(?!\1)(.)\2\1/
    String.match? sequence, abba
  end

  defp contains_aba_bab(%{snet: supernet, hnet: hypernet}) do


  end
end
