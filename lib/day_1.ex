defmodule AdventElixir.Day1 do
  @moduledoc ~S"""
  Day 1

  ## Examples

      iex> part1()
      278

      iex> part2()
      161
  """

  import AdventElixir.Input, only: [day1: 0]

  def part1 do
    day1()
    |> prepare_input()
    |> Enum.reduce(%{x: 0, y: 0, facing: :north}, &move(&1, &2))
    |> get_distance()
  end

  def part2 do
    day1()
    |> prepare_input()
    |> Enum.scan(%{x: 0, y: 0, facing: :north}, &move2(&1, &2))
    |> Enum.flat_map(fn x -> x end)
    |> Enum.map(fn pos -> %{x: pos.x, y: pos.y} end)
    |> Enum.reduce_while([], &dupe_finder(&1, &2))
    |> get_distance()
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/,\s+/)
  end

  defp move("L" <> num, %{x: x, y: y, facing: facing} = pos) do
    num = String.to_integer num
    case facing do
      :east -> %{pos | y: y + num, facing: :north}
      :north -> %{pos | x: x - num, facing: :west}
      :west -> %{pos | y: y - num, facing: :south}
      :south -> %{pos | x: x + num, facing: :east}
    end
  end
  defp move("R" <> num, %{x: x, y: y, facing: facing} = pos) do
    num = String.to_integer num
    case facing do
      :east -> %{pos | y: y - num, facing: :south}
      :north -> %{pos | x: x + num, facing: :east}
      :west -> %{pos | y: y + num, facing: :north}
      :south -> %{pos | x: x - num, facing: :west}
    end
  end

  defp move2(command, %{} = pos), do: move2 command, [pos]
  defp move2("L" <> num, [%{facing: facing} = pos | _]) do
    num = String.to_integer num
    Enum.reverse(case facing do
      :east -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y + 1, facing: :north} end)
      :north -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x - 1, facing: :west} end)
      :west -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y - 1, facing: :south} end)
      :south -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x + 1, facing: :east} end)
    end)
  end
  defp move2("R" <> num, [%{facing: facing} = pos | _]) do
    num = String.to_integer num
    Enum.reverse(case facing do
      :east -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y - 1, facing: :south} end)
      :north -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x + 1, facing: :east} end)
      :west -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y + 1, facing: :north} end)
      :south -> num..1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x - 1, facing: :west} end)
    end)
  end

  defp get_distance(%{x: x, y: y}), do: abs(x) + abs(y)

  defp dupe_finder(pos, acc) do
    case Enum.member? acc, pos do
      true -> {:halt, pos}
      false -> {:cont, [pos | acc]}
    end
  end
end
