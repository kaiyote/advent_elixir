defmodule AdventElixir.Day15 do
  @moduledoc """
  Day 15

  ## Examples

    iex> part1(AdventElixir.Input.day15)
    317371

    iex> part2(AdventElixir.Input.day15)
    2080951
  """

  def part1(input) do
    input
    |> prepare_input()
    |> time_stream()
    |> Stream.filter(fn {v, _} -> v end)
    |> Stream.take(1)
    |> Enum.fetch!(0)
    |> (fn {_, t} -> t end).()
  end

  def part2(input) do
    input
    |> prepare_input()
    |> List.insert_at(-1, %{"count" => "11", "pos" => "0", "disc_num" => "7"})
    |> time_stream()
    |> Stream.filter(fn {v, _} -> v end)
    |> Stream.take(1)
    |> Enum.fetch!(0)
    |> (fn {_, t} -> t end).()
  end

  defp prepare_input(input) do
    lines = input
    |> String.trim()
    |> String.split(~r/(\r|\n)/, trim: true)

    for line <- lines do
      Regex.named_captures ~r/(?<disc_num>\d{1,}).*?(?<count>\d{1,}).+?\d,.+?(?<pos>\d{1,})/, line
    end
  end

  defp will_be_zero_at_drop_time(%{"count" => count, "pos" => pos, "disc_num" => num}, time) do
    [count, pos, num] = Enum.map [count, pos, num], &String.to_integer/1

    rem(time + num + pos, count) == 0
  end

  defp time_stream(disc_map) do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.map(fn t -> Enum.all?(disc_map, fn disc -> will_be_zero_at_drop_time disc, t end) end)
    |> Stream.with_index()
  end
end
