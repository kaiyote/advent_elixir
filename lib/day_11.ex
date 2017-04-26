defmodule AdventElixir.Day11 do
  @moduledoc ~S"""
  Day 9

  ## Examples

      iex> part1("The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
      ...> The second floor contains a hydrogen generator.
      ...> The third floor contains a lithium generator.
      ...> The fourth floor contains nothing relevant.")
      11
  """

  def part1(input) do
    input
    |> prepare_start_state()
  end

  defp prepare_start_state(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/)
    |> Enum.map(&String.trim/1)
    |> generate_initial_state()
  end

  defp generate_initial_state(state_descriptors, state_map \\ %{})
  defp generate_initial_state([], state_map), do: state_map
  defp generate_initial_state([description | rest], state_map) do
    map = process_description description, state_map

    generate_initial_state rest, map
  end

  defp process_description("The first floor contains " <> contents, state_map) do
    floor_contents = contents
      |> String.split(~r/( and a )|(\s?a )/, trim: true)
      |> Enum.map(&String.split(&1))
    build_floor 1, contents, state_map
  end
  defp process_description("The second floor contains " <> contents, state_map) do
    build_floor 2, contents, state_map
  end
  defp process_description("The third floor contains " <> contents, state_map) do
    build_floor 3, contents, state_map
  end
  defp process_description("The fourth floor contains " <> contents, state_map) do
    build_floor 4, contents, state_map
  end
end
