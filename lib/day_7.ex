defmodule AdventElixir.Day7 do
  @moduledoc ~S"""
  Day 7

  ## Examples

      iex> part1(AdventElixir.Input.day7)
      110

      iex> part2(AdventElixir.Input.day7)
      242
  """

  def part1(input) do
    input
    |> prepare_input()
    |> Enum.count(fn %{snet: snet, hnet: hnet} ->
      Enum.any?(snet, &contains_abba/1) && Enum.all?(hnet, &(not contains_abba(&1))) end)
  end

  def part2(input) do
    input
    |> prepare_input()
    |> Enum.count(&contains_aba_bab/1)
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> create_ip7_map()))
  end

  def create_ip7_map(line) do
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

  def contains_aba_bab(%{snet: supernet, hnet: hypernet}) do
    potential_abas = supernet
      |> Enum.flat_map(&(&1 |> String.to_charlist |> Enum.chunk(3, 1)
        |> Enum.map(fn c -> List.to_string(c) end)))
      |> Enum.filter(&String.match?(&1, ~r/(.)(?!\1)(.)\1/))

    potential_babs = hypernet
      |> Enum.flat_map(&(&1 |> String.to_charlist |> Enum.chunk(3, 1)
        |> Enum.map(fn c -> List.to_string(c) end)))
      |> Enum.filter(&String.match?(&1, ~r/(.)(?!\1)(.)\1/))
      |> Enum.map(&bab_to_aba/1)

    potential_abas
    |> Enum.any?(fn aba -> Enum.member?(potential_babs, aba) end)
  end

  def bab_to_aba(bab) do
    a = String.at(bab, 1)
    b = String.at(bab, 0)
    a <> b <> a
  end
end
