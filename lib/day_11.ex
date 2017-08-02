defmodule AdventElixir.Day11 do
  @moduledoc ~S"""
  Day 11

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
    |> String.split(~r/(\r|\n)/, trim: true)
    |> Enum.map(&(&1 |> String.trim() |> String.replace(".", "")))
    |> generate_initial_state()
  end

  defp generate_initial_state(state_descriptors, state_map \\ %{})
  defp generate_initial_state([], state_map), do: state_map
  defp generate_initial_state([description | rest], state_map) do
    map = process_description description, state_map

    generate_initial_state rest, map
  end

  defp process_description("The first floor contains " <> contents, state_map) do
    process_description contents, 1, state_map
  end
  defp process_description("The second floor contains " <> contents, state_map) do
    process_description contents, 2, state_map
  end
  defp process_description("The third floor contains " <> contents, state_map) do
    process_description contents, 3, state_map
  end
  defp process_description("The fourth floor contains " <> contents, state_map) do
    process_description contents, 4, state_map
  end
  defp process_description(contents, floor_num, state_map) do
    floor_contents = contents
      |> String.split(~r/( and a )|(\s?a )/, trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))

    build_floor floor_contents, floor_num, state_map
  end

  defp build_floor([], _floor, state_map), do: state_map
  defp build_floor([["nothing", "relevant"]], floor, state_map) do
    Map.put(state_map, floor, %{generators: [], microchips: []})
  end
  defp build_floor([[element, "generator"] | rest], floor, state_map) do
    map = Map.update(state_map, floor, %{generators: [String.to_atom(element)], microchips: []},
      fn current -> %{current | generators: [String.to_atom(element), current.generators]} end)
    build_floor rest, floor, map
  end
  defp build_floor([[element, "microchip"] | rest], floor, state_map) do
    element = element |> String.split("-") |> hd() |> String.to_atom()
    map = Map.update(state_map, floor, %{generators: [], microchips: [element]},
      fn current -> %{current | microchips: [element | current.microchips]} end)
    build_floor rest, floor, map
  end
end
