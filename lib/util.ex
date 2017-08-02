defmodule AdventElixir.Util do
  @moduledoc false

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def sorted_rle(items) when is_list(items) do
    items
    |> List.to_string()
    |> sorted_rle()
  end
  def sorted_rle(<< first :: binary-size(1), rest :: binary>>) do
    sorted_rle(rest, first, %{})
  end
  def sorted_rle("", char, result) do
    Map.update(result, char, 1, &(&1 + 1))
  end
  def sorted_rle(<< next :: binary-size(1), rest :: binary>>, char, result) do
    result = Map.update(result, char, 1, &(&1 + 1))
    sorted_rle(rest, next, result)
  end
end

defmodule AdventElixir.Util.Point do
  @moduledoc false

  @enforce_keys ~w(x y)a
  defstruct ~w(x y)a

  def add(%__MODULE__{} = point, x \\ 0, y \\ 0) do
    %{point | x: point.x + x, y: point.y + y}
  end
end
