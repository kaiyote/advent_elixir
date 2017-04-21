defmodule AdventElixir.Day5 do
  @moduledoc ~S"""
  Day 5

  ## Examples

      iex> part1()
      "d4cd2ee1"

      iex> part2()
      "f2c730e5"
  """

  import AdventElixir.Input, only: [day5: 0]

  def part1 do
    day5()
    |> prepare_input()
    |> Stream.filter_map(&String.starts_with?(&1, "00000"), &String.at(&1, 5))
    |> Stream.take(8)
    |> Enum.join()
  end

  def part2 do
    day5()
    |> prepare_input()
    |> Stream.filter_map(
      &(String.starts_with?(&1, "00000") && String.at(&1, 5) in ~w(0 1 2 3 4 5 6 7)),
      &({&1 |> String.at(5) |> String.to_integer(), String.at(&1, 6)}))
    |> Stream.uniq_by(fn {pos, _} -> pos end)
    |> Stream.take(8)
    |> Enum.sort_by(fn {k, _} -> k end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.join()
  end

  defp prepare_input(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&(:md5 |> :crypto.hash(input <> Integer.to_string(&1)) |> Base.encode16
                  |> String.downcase))
  end
end
