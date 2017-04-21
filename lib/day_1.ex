defmodule AdventElixir.Day1 do
  @moduledoc ~S"""
  Day 1

  ## Examples

      iex> part1()
      278

      iex> part2()
      161
  """

  @input "L1, R3, R1, L5, L2, L5, R4, L2, R2, R2, L2, R1, L5, R3, L4, L1, L2, R3, R5, L2, R5, L1,
  R2, L5, R4, R2, R2, L1, L1, R1, L3, L1, R1, L3, R5, R3, R3, L4, R4, L2, L4, R1, R1, L193, R2, L1,
  R54, R1, L1, R71, L4, R3, R191, R3, R2, L4, R3, R2, L2, L4, L5, R4, R1, L2, L2, L3, L2, L1, R4,
  R1, R5, R3, L5, R3, R4, L2, R3, L1, L3, L3, L5, L1, L3, L3, L1, R3, L3, L2, R1, L3, L1, R5, R4,
  R3, R2, R3, L1, L2, R4, L3, R1, L1, L1, R5, R2, R4, R5, L1, L1, R1, L2, L4, R3, L1, L3, R5, R4,
  R3, R3, L2, R2, L1, R4, R2, L3, L4, L2, R2, R2, L4, R3, R5, L2, R2, R4, R5, L2, L3, L2, R5, L4,
  L2, R3, L5, R2, L1, R1, R3, R3, L5, L2, L2, R5"

  def part1 do
    @input
    |> String.trim()
    |> String.split(~r/,\s+/, [])
    |> Enum.reduce(%{x: 0, y: 0, facing: :north}, &move(&1, &2))
    |> get_distance()
  end

  def part2 do
    @input
    |> String.trim()
    |> String.split(~r/,\s+/, [])
    |> Enum.scan(%{x: 0, y: 0, facing: :north}, &move2(&1, &2))
    |> Enum.flat_map(fn x -> x end)
    |> Enum.map(fn pos -> %{x: pos.x, y: pos.y} end)
    |> Enum.reduce_while([], &dupe_finder(&1, &2))
    |> get_distance()
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

  def move2(command, %{} = pos), do: move2 command, [pos]
  def move2("L" <> num, [%{facing: facing} = pos | _]) do
    num = String.to_integer num
    case facing do
      :east -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y + 1, facing: :north} end) |> Enum.reverse()
      :north -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x - 1, facing: :west} end) |> Enum.reverse()
      :west -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y - 1, facing: :south} end) |> Enum.reverse()
      :south -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x + 1, facing: :east} end) |> Enum.reverse()
    end
  end
  def move2("R" <> num, [%{facing: facing} = pos | _]) do
    num = String.to_integer num
    case facing do
      :east -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y - 1, facing: :south} end) |> Enum.reverse()
      :north -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x + 1, facing: :east} end) |> Enum.reverse()
      :west -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | y: pos.y + 1, facing: :north} end) |> Enum.reverse()
      :south -> num .. 1 |> Enum.scan(pos, fn _, pos -> %{pos | x: pos.x - 1, facing: :west} end) |> Enum.reverse()
    end
  end

  defp get_distance(%{x: x, y: y}), do: abs(x) + abs(y)

  defp dupe_finder(pos, acc) do
    case Enum.member? acc, pos do
      true -> {:halt, pos}
      false -> {:cont, [pos | acc]}
    end
  end
end
