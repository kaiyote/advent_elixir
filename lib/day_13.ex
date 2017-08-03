defmodule AdventElixir.Day13 do
  alias AdventElixir.Util.Point
  @moduledoc ~S"""
  Day 13

  ## Examples

    iex> alias AdventElixir.Util.Point
    iex> part1(AdventElixir.Input.day13, %Point{x: 31, y: 39})
    86

    iex> alias AdventElixir.Util.Point
    iex> part2(AdventElixir.Input.day13, %Point{x: 31, y: 39})
    127
  """

  def part1(code, dest) do
    start = %{pos: %Point{x: 1, y: 1}, dist: 0}

    {dist, _} = breadth_first_search dest, :queue.from_list([start]), [], code
    dist
  end

  def part2(code, dest) do
    start = %{pos: %Point{x: 1, y: 1}, dist: 0}

    {_, visited} = breadth_first_search dest, :queue.from_list([start]), [], code

    visited
    |> Enum.filter(fn %{dist: dist} -> dist <= 50 end)
    |> Enum.map(fn %{pos: pos} -> pos end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp breadth_first_search(dest, queue, visited, code) do
    case :queue.out queue do
      {:empty, _} -> :empty
      {{:value, %{pos: pos, dist: dist} = cur}, que} ->
        if pos == dest do
          {dist, visited}
        else
          visited = [cur | visited]
          queu = Enum.reduce(gen_neighbors(pos, dist, visited, code), que, fn p, q -> :queue.in p, q end)
          breadth_first_search dest, queu, visited, code
        end
    end
  end

  def gen_neighbors(pos, dist, visited, code) do
    possible = for x <- -1..1, y <- -1..1, abs(x + y) == 1, do: Point.add pos, x, y

    possible
    |> Enum.filter(fn %{x: x, y: y} -> x >= 0 && y >= 0 end)
    |> Enum.filter(&(visited |> Enum.map(fn %{pos: p} -> p end) |> Enum.member?(&1) |> Kernel.!()))
    |> Enum.filter(&is_open(&1, code))
    |> Enum.map(fn p -> %{pos: p, dist: dist + 1} end)
  end

  defp is_open(%{x: x, y: y}, code) do
    init_val = x * x + 3 * x + 2 * x * y + y + y * y + code

    init_val
    |> Integer.to_string(2)
    |> String.replace("0", "")
    |> String.length()
    |> Kernel.rem(2)
    |> Kernel.==(0)
  end
end
