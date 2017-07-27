defmodule AdventElixir.Day4 do
  @moduledoc ~S"""
  Day 4

  ## Examples

      iex> part1(AdventElixir.Input.day4)
      137896

      iex> part2(AdventElixir.Input.day4)
      501
  """

  import AdventElixir.Util

  def part1(input) do
    input
    |> prepare_input()
    |> Enum.filter(&valid?/1)
    |> Enum.reduce(0, fn %{sec_id: id}, acc -> acc + id end)
  end

  def part2(input) do
    input
    |> prepare_input()
    |> Enum.filter(&valid?/1)
    |> Enum.map(&(%{&1 | enc_name: decode(&1.enc_name, &1.sec_id)}))
    |> Enum.filter(fn %{enc_name: name} -> String.contains?(name, "north") &&
                                          String.contains?(name, "pole") end)
    |> hd()
    |> (fn %{sec_id: id} -> id end).()
  end

  defp prepare_input(input) do
    input
    |> String.trim()
    |> String.split(~r/(\r|\n)/, trim: true)
    |> Enum.map(&(&1 |> String.trim() |> make_room_struct()))
  end

  defp make_room_struct(line) do
    [name, id_sum] = String.split line, ~r/-(?=\d)/
    [id, sum] = id_sum |> String.replace(~r/(\[|\])/, "") |> String.split(~r/(?<=\d)(?!\d)/, trim: true)
    %{enc_name: name, sec_id: String.to_integer(id), checksum: sum}
  end

  defp valid?(%{enc_name: name, checksum: sum}) do
    check = name
    |> String.replace("-", "")
    |> sorted_rle()
    |> Map.to_list()
    |> Enum.sort_by(&(&1), fn {lk, lv}, {rk, rv} -> if lv == rv, do: lk <= rk, else: lv >= rv end)
    |> Enum.take(5)
    |> Enum.map_join(fn {k, _} -> k end)

    check == sum
  end

  def decode(encrypted, shift_amount) do
    encrypted
    |> String.to_charlist()
    |> Enum.map(&cycle_char(&1, shift_amount))
    |> List.to_string()
    |> String.replace("_", " ")
  end

  def cycle_char(c, 0), do: c
  def cycle_char(?-, _), do: ?_
  def cycle_char(?z, x), do: cycle_char(?a, x - 1)
  def cycle_char(c, x), do: cycle_char(c + 1, x - 1)
end
