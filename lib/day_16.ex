defmodule AdventElixir.Day16 do
  @moduledoc """
  Day 16

  ## Examples

    iex> part1(AdventElixir.Input.day16(), 272)
    "11100110111101110"

    iex> part1(AdventElixir.Input.day16(), 35651584)
    "10001101010000101"
  """

  def part1(initial_state, size) do
    initial_state
    |> Stream.iterate(&dragonize/1)
    |> Stream.drop_while(fn str -> String.length(str) < size end)
    |> Stream.take(1)
    |> Enum.fetch!(0)
    |> String.slice(0, size)
    |> Stream.iterate(&checksum/1)
    |> Stream.drop_while(fn sum -> rem(String.length(sum), 2) == 0 end)
    |> Stream.take(1)
    |> Enum.fetch!(0)
  end

  defp dragonize(input) do
    b = input
    |> String.split("", trim: true)
    |> Enum.reduce("", fn c, acc -> acc <> if c == "0", do: "1", else: "0" end)
    |> String.reverse

    input <> "0" <> b
  end

  defp checksum(input) do
    input
    |> String.split("", trim: true)
    |> Enum.chunk_every(2)
    |> Enum.reduce("", fn [a, b], acc -> acc <> if a == b, do: "1", else: "0" end)
  end
end
