defmodule AdventElixir.Day14 do
  @moduledoc ~S"""
  Day 14

  ## Examples

    iex> part1(AdventElixir.Input.day14)
    16106

    iex> part2(AdventElixir.Input.day14)
    22423
  """

  def part1(input) do
    input
    |> prepare_input()
    |> (fn {pid, stream} -> {pid, filter_to_3same(stream)} end).()
    |> (fn {pid, stream} -> {pid, filter_to_match5(pid, stream, input)} end).()
    |> (fn {pid, stream} -> {pid, Stream.take(stream, 64)} end).()
    |> (fn {pid, stream} -> {pid, Enum.fetch!(stream, 63)} end).()
    |> (fn {pid, {_, idx, _}} ->
      Agent.stop pid
      idx
    end).()
  end

  def part2(input) do
    input
    |> prepare_input(2017)
    |> (fn {pid, stream} -> {pid, filter_to_3same(stream)} end).()
    |> (fn {pid, stream} -> {pid, filter_to_match5(pid, stream, input, 2017)} end).()
    |> (fn {pid, stream} -> {pid, Stream.take(stream, 64)} end).()
    |> (fn {pid, stream} -> {pid, Enum.fetch!(stream, 63)} end).()
    |> (fn {pid, {_, idx, _}} ->
      Agent.stop pid
      idx
    end).()
  end

  defp prepare_input(input, count \\ 1) do
    {:ok, pid} = Agent.start_link fn -> %{} end

    {pid, 0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.map(&get_or_compute_hash(&1, input, pid, count))
    |> Stream.with_index()}
  end

  defp get_or_compute_hash(seed, salt, pid, count) do
    case Agent.get pid, &Map.fetch(&1, seed) do
      {:ok, val} -> val
      :error ->
        hash = Enum.reduce(1..count, salt <> Integer.to_string(seed), fn _, acc -> hasher acc end)
        Agent.update pid, &Map.put(&1, seed, hash)
        hash
    end
  end

  defp hasher(string) do
    :md5 |> :crypto.hash(string) |> Base.encode16() |> String.downcase()
  end

  defp filter_to_3same(stream) do
    regex = ~r/.*?(.)\1\1/

    stream
    |> Stream.filter(fn {hash, _idx} -> hash =~ regex end)
    |> Stream.map(fn {hash, idx} -> {hash, idx, matcher_regex(hash)} end)
  end

  defp matcher_regex(hash) do
    char = Enum.fetch! Regex.run(~r/.*?(.)\1\1/, hash, capture: :all_but_first), 0
    {:ok, reg} = Regex.compile ".*?#{char}{5}"
    reg
  end

  defp filter_to_match5(pid, stream, salt, count \\ 1) do
    stream
    |> Stream.filter(fn {_hash, idx, matcher} ->
      Enum.any?(generate_sub_stream(pid, idx + 1, salt, count), &(&1 =~ matcher))
    end)
  end

  defp generate_sub_stream(pid, index, salt, count) do
    index
    |> Stream.iterate(&(&1 + 1))
    |> Stream.map(&get_or_compute_hash(&1, salt, pid, count))
    |> Stream.take(1000)
  end
end
