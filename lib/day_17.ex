defmodule AdventElixir.Day17 do
  @moduledoc """
  Day 17

  ## Examples

    iex> part1(AdventElixir.Input.day17)
    "RRRLDRDUDD"

    iex> part2(AdventElixir.Input.day17)
    706
  """

  alias AdventElixir.Util.Point

  def part1(input) do
    start = %{pos: %Point{x: 0, y: 0}, path: ""}

    breadth_first_search :queue.from_list([start]), input
  end

  def part2(input) do
    %{pos: %Point{x: 0, y: 0}, path: ""}
    |> List.wrap
    |> :queue.from_list
    |> breadth_first_search2(input)
    |> Enum.sort_by(&byte_size/1, &>=/2)
    |> Enum.fetch!(0)
    |> String.length
  end

  defp breadth_first_search(queue, code) do
    case :queue.out queue do
      {:empty, _} -> :empty
      {{:value, %{pos: pos, path: path}}, que} ->
        if pos == %Point{x: 3, y: 3} do
          path
        else
          queu = Enum.reduce(gen_neighbors(pos, path, code), que, fn p, q -> :queue.in p, q end)
          breadth_first_search queu, code
        end
    end
  end

  defp breadth_first_search2(queue, code, paths \\ []) do
    case :queue.out queue do
      {:empty, _} -> paths
      {{:value, %{pos: pos, path: path}}, que} ->
        if pos == %Point{x: 3, y: 3} do
          breadth_first_search2 que, code, [path | paths]
        else
          queu = Enum.reduce(gen_neighbors(pos, path, code), que, fn p, q -> :queue.in p, q end)
          breadth_first_search2 queu, code, paths
        end
    end
  end

  defp gen_neighbors(pos, path, code) do
    possible = for x <- -1..1, y <- -1..1, abs(x + y) == 1, do: Point.add pos, x, y

    possible
    |> Enum.filter(fn %{x: x, y: y} -> x in 0..3 && y in 0..3 end)
    |> Enum.filter(&is_open(gen_dir(&1, pos), path, code))
    |> Enum.map(fn p -> %{pos: p, path: path <> gen_dir(p, pos)} end)
  end

  defp gen_dir(%{x: x_target, y: y_target}, %{x: x_cur, y: y_cur}) do
    case {x_target - x_cur, y_target - y_cur} do
      {-1, 0} -> "L"
      {1, 0} -> "R"
      {0, -1} -> "U"
      {0, 1} -> "D"
    end
  end

  defp is_open(dir, path, code) do
    hash = :md5 |> :crypto.hash(code <> path) |> Base.encode16 |> String.downcase

    index = case dir do
      "U" -> 0
      "D" -> 1
      "L" -> 2
      "R" -> 3
    end

    String.at(hash, index) in ~w(b c d e f)
  end
end
