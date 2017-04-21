defmodule AdventElixir.Day3 do
  @moduledoc ~S"""
  Day 3

  ## Examples

      iex> part1()
      982

      iex> part2()
      1826
  """

  import AdventElixir.Input, only: [day3: 0]

  def part1 do
    day3()
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> String.split(~r/\s+/)
                |> Enum.map(fn s -> String.to_integer(s) end) |> Enum.sort()))
    |> Enum.count(fn [x, y, z] -> x + y > z end)
  end

  def part2 do
    day3()
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&(&1 |> String.trim() |> String.split(~r/\s+/)
                  |> Enum.map(fn s -> String.to_integer(s) end)))
    |> Enum.reduce([[], [], []],
                   fn [x, y, z], [colx, coly, colz] -> [[x | colx], [y | coly], [z | colz]] end)
    |> Enum.map(&(&1 |> Enum.reverse() |> Enum.chunk(3)))
    |> Enum.flat_map(&(&1))
    |> Enum.map(&Enum.sort(&1))
    |> Enum.count(fn [x, y, z] -> x + y > z end)
  end
end
