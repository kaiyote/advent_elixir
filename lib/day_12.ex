defmodule AdventElixir.Day12 do
  @moduledoc ~S"""
  Day 12

  ## Examples

    iex> part1("cpy 41 a
    ...> inc a
    ...> inc a
    ...> dec a
    ...> jnz a 2
    ...> dec a")
    42

    iex> part1(AdventElixir.Input.day12())
    318020

    iex> part2(AdventElixir.Input.day12())
    9227674
  """

  def part1(input) do
    input
    |> prepare_input
    |> process_commands(0, %{a: 0, b: 0, c: 0, d: 0})
    |> (fn m -> m[:a] end).()
  end

  def part2(input) do
    input
    |> prepare_input
    |> process_commands(0, %{a: 0, b: 0, c: 1, d: 0})
    |> (fn m -> m[:a] end).()
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/, trim: true)
    |> Enum.map(&(&1 |> String.split(" ", trim: true) |> build_command()))
  end

  defp build_command(["cpy", x, reg]) when x in ~w(a b c d) do
    %{command: :cpy, register: String.to_atom(reg), value: String.to_atom(x)}
  end
  defp build_command(["cpy", x, reg]) do
    %{command: :cpy, register: String.to_atom(reg), value: String.to_integer(x)}
  end
  defp build_command(["inc", reg]) do
    %{command: :inc, register: String.to_atom(reg)}
  end
  defp build_command(["dec", reg]) do
    %{command: :dec, register: String.to_atom(reg)}
  end
  defp build_command(["jnz", reg, x]) do
    %{command: :jnz, register: String.to_atom(reg), value: String.to_integer(x)}
  end

  defp process_commands(commands, command_index, state) do
    case Enum.at(commands, command_index) do
      nil -> state
      %{command: :jnz, register: reg, value: x} ->
        if state[reg] != 0 do
          process_commands commands, command_index + x, state
        else
          process_commands commands, command_index + 1, state
        end
      %{command: :cpy, register: reg, value: x} when x in ~w(a b c d)a ->
        process_commands commands, command_index + 1, Map.update!(state, reg, fn _ -> state[x] end)
      %{command: :cpy, register: reg, value: x} ->
        process_commands commands, command_index + 1, Map.update!(state, reg, fn _ -> x end)
      %{command: :inc, register: reg} ->
        process_commands commands, command_index + 1, Map.update!(state, reg, fn x -> x + 1 end)
      %{command: :dec, register: reg} ->
        process_commands commands, command_index + 1, Map.update!(state, reg, fn x -> x - 1 end)
    end
  end
end
