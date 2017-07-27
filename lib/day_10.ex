defmodule AdventElixir.Day10 do
  @moduledoc ~S"""
  Day 9

  ## Examples

      iex> part1(5, 2, "value 5 goes to bot 2
      ...> bot 2 gives low to bot 1 and high to bot 0
      ...> value 3 goes to bot 1
      ...> bot 1 gives low to output 1 and high to bot 0
      ...> bot 0 gives low to output 2 and high to output 0
      ...> value 2 goes to bot 2")
      "2"
      iex> part1(61, 17, AdventElixir.Input.day10())
      "93"

      iex> part2(AdventElixir.Input.day10())
      47101
  """

  def part1(chip_one, chip_two, instructions) do
    commands = prepare_input instructions
    seed_map = process_seed(Enum.filter(commands, fn %{type: t} -> t == :seed end))

    process(Enum.filter(commands, fn %{type: t} -> t != :seed end), [chip_one, chip_two], seed_map)
  end

  def part2(instructions) do
    commands = prepare_input instructions
    seed_map = process_seed(Enum.filter(commands, fn %{type: t} -> t == :seed end))

    process_v2(Enum.filter(commands, fn %{type: t} -> t != :seed end), seed_map)
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/, trim: true)
    |> Enum.map(&(&1 |> String.trim() |> String.split(" ") |> make_command()))
  end

  defp make_command(["value", value, "goes", "to", "bot", bot]) do
    %{type: :seed, target: bot, value: String.to_integer(value)}
  end
  defp make_command(["bot", bot, "gives", "low", "to", low_t, low,
                     "and", "high", "to", high_t, high]) do
    %{type: :distribute, source: bot, t_low: build_target(low_t, low),
      t_high: build_target(high_t, high)}
  end

  defp build_target("output", value), do: "o" <> value
  defp build_target("bot", value), do: value

  defp process_seed(seed_arr, bot_map \\ %{})
  defp process_seed([], bot_map), do: bot_map
  defp process_seed([%{type: :seed, target: bot, value: value} | rest], bot_map) do
    bot_map = Map.update bot_map, bot, [value], fn arr -> [value | arr] end
    process_seed rest, bot_map
  end

  defp process([], value_arr, bot_map) do
    find_target_bot(value_arr, bot_map)
  end
  defp process([command | rest], value_arr, bot_map) do
    case find_target_bot(value_arr, bot_map) do
      :error -> process_command(command, rest, value_arr, bot_map)
      {k, _} -> k
    end
  end

  defp process_v2([command | rest], bot_map) do
    case compute_final_number(bot_map) do
      :error -> process_command_v2(command, rest, bot_map)
      x -> x
    end
  end

  defp find_target_bot([val1, val2], bot_map) do
    bot_map |> Map.to_list |> Enum.find(:error, fn {_, v} ->
      Enum.member?(v, val1) && Enum.member?(v, val2) end)
  end

  defp compute_final_number(bot_map) do
    with [value0] <- Map.get(bot_map, "o0", :error),
         [value1] <- Map.get(bot_map, "o1", :error),
         [value2] <- Map.get(bot_map, "o2", :error),
         do: value0 * value1 * value2
  end

  defp process_command(%{source: bot, t_low: t_low, t_high: t_high} = command,
                       rest, value_arr, bot_map) do
    case Map.get bot_map, bot, [] do
      [val1, val2] ->
        bot_map = [val1, val2] |> Enum.min_max() |> (fn {low, high} ->
          bot_map
          |> Map.update!(bot, fn _ -> [] end)
          |> Map.update(t_low, [low], fn arr -> [low | arr] end)
          |> Map.update(t_high, [high], fn arr -> [high | arr] end)
        end).()
        process rest, value_arr, bot_map
      _ -> process(rest ++ [command], value_arr, bot_map)
    end
  end

  defp process_command_v2(%{source: bot, t_low: t_low, t_high: t_high} = command, rest, bot_map) do
    case Map.get bot_map, bot, [] do
      [val1, val2] ->
        bot_map = [val1, val2] |> Enum.min_max() |> (fn {low, high} ->
          bot_map
          |> Map.update!(bot, fn _ -> [] end)
          |> Map.update(t_low, [low], fn arr -> [low | arr] end)
          |> Map.update(t_high, [high], fn arr -> [high | arr] end)
        end).()
        process_v2 rest, bot_map
      _ -> process_v2(rest ++ [command], bot_map)
    end
  end
end
