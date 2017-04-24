defmodule AdventElixir.Day9 do
  @moduledoc ~S"""
  Day 9

  ## Examples

      iex> part1("ADVENT")
      6
      iex> part1("A(1x5)BC")
      7
      iex> part1("(3x3)XYZ")
      9
      iex> part1("A(2x2)BCD(2x2)EFG")
      11
      iex> part1("(6x1)(1x3)A")
      6
      iex> part1("X(8x2)(3x3)ABCY")
      18
      iex> part1(AdventElixir.Input.day9())
      97714

      iex> part2("(3x3)XYZ")
      9
      iex> part2("X(8x2)(3x3)ABCY")
      20
      iex> part2("(27x12)(20x12)(13x14)(7x10)(1x12)A")
      241920
      iex> part2("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
      445
      iex> part2(AdventElixir.Input.day9())
      10762972461
  """

  def part1(input) do
    input
    |> prepare_input()
    |> make_tokens()
    |> make_nodes()
    |> interpret()
    |> String.length()
  end

  def part2(input) do
    input
    |> prepare_input()
    |> make_tokens()
    |> make_nodes_v2()
    |> interpret_v2()
  end

  defp prepare_input(input) do
    input
    |> String.replace(~r/\s/, "")
    |> String.split("")
  end

  defp make_tokens(input) do
    input
    |> Enum.map(&char_to_token/1)
  end

  defp char_to_token("x"), do: %{type: :mult_div, value: "x"}
  defp char_to_token("("), do: %{type: :mult_start, value: "("}
  defp char_to_token(")"), do: %{type: :mult_end, value: ")"}
  defp char_to_token(""), do: %{type: :eof, value: ""}
  defp char_to_token(c) when c in ~w(1 2 3 4 5 6 7 8 9 0) do
    %{type: :num, value: c}
  end
  defp char_to_token(c), do: %{type: :char, value: c}

  defp make_nodes(tokens, nodes \\ [])
  defp make_nodes([%{type: :eof} | _], nodes), do: Enum.reverse nodes
  defp make_nodes([%{type: :char, value: value} | rest], nodes) do
    make_nodes rest, [%{type: :single_char, value: value} | nodes]
  end
  defp make_nodes([%{type: :mult_start} | rest], nodes) do
    {leftover, multiplier} = make_multiplier rest
    make_nodes leftover, [multiplier | nodes]
  end

  defp make_nodes_v2(tokens, nodes \\ [])
  defp make_nodes_v2([%{type: :eof} | _], nodes), do: Enum.reverse nodes
  defp make_nodes_v2([%{type: :char, value: value} | rest], nodes) do
    make_nodes_v2 rest, [%{type: :single_char, value: value} | nodes]
  end
  defp make_nodes_v2([%{type: :mult_start} | rest], nodes) do
    {leftover, multiplier} = make_multiplier_v2 rest
    make_nodes_v2 leftover, [multiplier | nodes]
  end

  defp make_multiplier(tokens) do
    {[%{type: :mult_div} | rest], amount} = make_number tokens
    {[%{type: :mult_end} | rest], times} = make_number rest
    {rest, repeat} = grab_repeat_string rest, amount
    {rest, %{type: :multiplier, times: times, value: repeat}}
  end

  defp grab_repeat_string(tokens, amount) do
    repeat_string = tokens
    |> Enum.take(amount)
    |> Enum.map(fn t -> t.value end)
    |> Enum.join()

    {Enum.drop(tokens, amount), repeat_string}
  end

  defp make_multiplier_v2(tokens) do
    {[%{type: :mult_div} | rest], amount} = make_number tokens
    {[%{type: :mult_end} | rest], times} = make_number rest
    {rest, repeat} = grab_repeat_string rest, amount
    repeat_tree = repeat
      |> String.split("")
      |> make_tokens()
      |> make_nodes_v2()
    {rest, %{type: :multiplier, times: times, tree: repeat_tree}}
  end

  defp make_number(tokens, int_string \\ "")
  defp make_number([%{type: :num, value: x} | rest], int_string) do
    make_number(rest, int_string <> x)
  end
  defp make_number(tokens, int_string) do
    {tokens, String.to_integer(int_string)}
  end

  defp interpret(nodes, result \\ "")
  defp interpret([], result), do: result
  defp interpret([%{type: :single_char, value: value} | rest], result) do
    interpret(rest, result <> value)
  end
  defp interpret([%{type: :multiplier, times: x, value: str} | rest], result) do
    sub_result = String.duplicate str, x
    interpret(rest, result <> sub_result)
  end

  defp interpret_v2(nodes, result \\ 0)
  defp interpret_v2([], result), do: result
  defp interpret_v2([%{type: :single_char, value: value} | rest], result) do
    interpret_v2(rest, result + 1)
  end
  defp interpret_v2([%{type: :multiplier, times: x, tree: tree} | rest], result) do
    sub_result = tree |> interpret_v2() |> (fn res -> res * x end).()

    interpret_v2(rest, result + sub_result)
  end
end
