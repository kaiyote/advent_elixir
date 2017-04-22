defmodule AdventElixir.Day8 do
  @moduledoc ~S"""
  Day 8

  ## Examples

      iex> part1()
      123

      iex> part2()
      :ok
  """

  import AdventElixir.Input, only: [day8: 0]
  import AdventElixir.Util

  def part1 do
    day8()
    |> prepare_input()
    |> process_commands(empty_screen(50, 6))
    |> List.flatten()
    |> Enum.count(&(&1 == 1))
  end

  def part2 do
    day8()
    |> prepare_input()
    |> process_commands(empty_screen(50, 6))
    |> print_screen()
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&String.trim/1)
  end

  defp print_screen(screen) do
    IO.puts("")
    IO.puts("Day 8 Part 2:")
    for row <- screen do
      IO.puts Enum.map(row, fn i -> if i == 0, do: '.', else: '#' end)
    end
    IO.puts("")
  end

  defp empty_screen(x, y) do
    0 |> List.duplicate(x) |> List.duplicate(y)
  end

  defp process_commands([], screen), do: screen
  defp process_commands(["rect " <> size | rest], screen) do
    [x, y] = size |> String.split("x") |> Enum.map(&String.to_integer/1)

    screen = Enum.map(Enum.with_index(screen), &rect_processor(&1, y, x))

    process_commands(rest, screen)
  end
  defp process_commands(["rotate column x=" <> col_and_amount | rest], screen) do
    [col, amount] = col_and_amount |> String.split(" by ") |> Enum.map(&String.to_integer/1)

    screen = screen
      |> transpose()
      |> Enum.with_index()
      |> Enum.map(&rotate_processor(&1, col, amount))
      |> transpose()

    process_commands(rest, screen)
  end
  defp process_commands(["rotate row y=" <> row_and_amount | rest], screen) do
    [row, amount] = row_and_amount |> String.split(" by ") |> Enum.map(&String.to_integer/1)

    screen = Enum.map(Enum.with_index(screen), &rotate_processor(&1, row, amount))

    process_commands(rest, screen)
  end

  defp rect_processor({row, index}, max_row_index, max_col_index) do
    if index < max_row_index do
        Enum.map(Enum.with_index(row), fn {l, i} -> if i < max_col_index, do: 1, else: l end)
      else
        row
      end
  end

  defp rotate_processor({row, index}, row_index, amount) do
    if index == row_index do
      amount = length(row) - amount
      tail = Enum.take(row, amount)
      head = Enum.drop(row, amount)
      head ++ tail
    else
      row
    end
  end
end
