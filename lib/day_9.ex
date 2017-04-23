defmodule AdventElixir.Day9 do
  @moduledoc ~S"""
  Day 9

  ## Examples

      iex> part1("ADVENT")
      6
      iex> part1("A(1x5)BC")
      7
      iex> part1("(3x3)XYZ")
      9
      iex> part1("A(2x2)BCD(2x2)EFG")
      11
      iex> part1("(6x1)(1x3)A")
      6
      iex> part1("X(8x2)(3x3)ABCY")
      18

      iex> part2("")
      0
  """

  def part1(input) do
    input
    |> prepare_input()
    |> make_tokens()
    |> make_nodes()
    |> interpret()
  end

  def part2(input) do
    input
  end

  defp prepare_input(input) do
    input
    |> String.replace(~r/\s/, "")
    |> String.split("")
  end

  defp make_tokens(input) do
    input
    |> Enum.map(&char_to_token/1)
  end

  defp char_to_token("x"), do: %{type: :mult_div}
  defp char_to_token("("), do: %{type: :mult_start}
  defp char_to_token(")"), do: %{type: :mult_end}
  defp char_to_token(c) when c in ~w(1 2 3 4 5 6 7 8 9 0) do
    %{type: :num, value: String.to_integer(c)}
  end
  defp char_to_token(c), do: %{type: :char, value: c}
end
