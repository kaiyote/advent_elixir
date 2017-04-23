defmodule AdventElixir.Day2 do
  @moduledoc ~S"""
  Day 2

  ## Examples

      iex> part1(AdventElixir.Input.day2)
      "48584"

      iex> part2(AdventElixir.Input.day2)
      "563B6"
  """

  def part1(input) do
    input
    |> prepare_input()
    |> Enum.scan(5, fn line, acc -> Enum.reduce(line, acc, &walk_standard_keypad(&1, &2)) end)
    |> Enum.join()
  end

  def part2(input) do
    input
    |> prepare_input()
    |> Enum.scan(5, fn line, acc -> Enum.reduce(line, acc, &walk_crazy_keypad(&1, &2)) end)
    |> Enum.map(&Integer.to_string(&1, 14)) # 1 - D == base 14 (1 - 13)
    |> Enum.join()
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> String.to_charlist()))
  end

  defp walk_standard_keypad(?U, x) when x in 1..3, do: x
  defp walk_standard_keypad(?U, x) when x in 4..9, do: x - 3
  defp walk_standard_keypad(?D, x) when x in 7..9, do: x
  defp walk_standard_keypad(?D, x) when x in 1..6, do: x + 3
  defp walk_standard_keypad(?L, x) when x in [1, 4, 7], do: x
  defp walk_standard_keypad(?L, x) when x in [2, 3, 5, 6, 8, 9], do: x - 1
  defp walk_standard_keypad(?R, x) when x in [3, 6, 9], do: x
  defp walk_standard_keypad(?R, x) when x in [1, 2, 4, 5, 7, 8], do: x + 1

  defp walk_crazy_keypad(?U, x) when x in [1, 2, 4, 5, 9], do: x
  defp walk_crazy_keypad(?U, x) when x in [6, 7, 8, 10, 11, 12], do: x - 4
  defp walk_crazy_keypad(?U, x) when x in [3, 13], do: x - 2
  defp walk_crazy_keypad(?D, x) when x in [5, 9, 10, 12, 13], do: x
  defp walk_crazy_keypad(?D, x) when x in [2, 3, 4, 6, 7, 8], do: x + 4
  defp walk_crazy_keypad(?D, x) when x in [1, 11], do: x + 2
  defp walk_crazy_keypad(?L, x) when x in [1, 2, 5, 10, 13], do: x
  defp walk_crazy_keypad(?L, x) when x in [3, 4, 6, 7, 8, 9, 11, 12], do: x - 1
  defp walk_crazy_keypad(?R, x) when x in [1, 4, 9, 12, 13], do: x
  defp walk_crazy_keypad(?R, x) when x in [2, 3, 5, 6, 7, 8, 10, 11], do: x + 1
end
