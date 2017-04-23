defmodule AdventElixir.Day6 do
  @moduledoc ~S"""
  Day 6

  ## Examples

      iex> part1(AdventElixir.Input.day6)
      "mshjnduc"

      iex> part2(AdventElixir.Input.day6)
      "apfeeebz"
  """

  import AdventElixir.Util

  def part1(input) do
    input
    |> prepare_input()
    |> Enum.map(&get_appropriate_character(&1, fn left, right -> left >= right end))
    |> Enum.join()
  end

  def part2(input) do
    input
    |> prepare_input()
    |> Enum.map(&get_appropriate_character(&1, fn left, right -> left <= right end))
    |> Enum.join()
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> String.to_charlist()))
    |> transpose()
  end

  defp get_appropriate_character(arr, sort_fun) do
    arr
    |> sorted_rle()
    |> Map.to_list()
    |> Enum.sort_by(fn {_, v} -> v end, sort_fun)
    |> hd()
    |> (fn {k, _} -> k end).()
  end
end
