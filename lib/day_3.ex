defmodule AdventElixir.Day3 do
  @moduledoc ~S"""
  Day 3

  ## Examples

      iex> part1(AdventElixir.Input.day3)
      982

      iex> part2(AdventElixir.Input.day3)
      1826
  """

  import AdventElixir.Util

  def part1(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> String.split(~r/\s+/)
                |> Enum.map(fn s -> String.to_integer(s) end) |> Enum.sort()))
    |> Enum.count(fn [x, y, z] -> x + y > z end)
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> String.split(~r/\s+/)
                  |> Enum.map(fn s -> String.to_integer(s) end)))
    |> transpose()
    |> Enum.map(&(&1 |> Enum.reverse() |> Enum.chunk(3)))
    |> Enum.flat_map(&(&1))
    |> Enum.map(&Enum.sort(&1))
    |> Enum.count(fn [x, y, z] -> x + y > z end)
  end
end
