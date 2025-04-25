defmodule Day16.BeamContraption do
  def parse_contraption_map(input) do
    input
    |> String.split("\n", trim: true)
  end

  defp tile_at(map, {_, x, y}) do
    cond do
      x < 0 -> nil
      y < 0 -> nil
      x >= String.length(hd(map)) -> nil
      y >= length(map) -> nil
      true -> Enum.at(map, y) |> String.at(x)
    end
  end

  defp next_position({dir, x, y}) do
    case dir do
      :left -> {dir, x - 1, y}
      :right -> {dir, x + 1, y}
      :up -> {dir, x, y - 1}
      :down -> {dir, x, y + 1}
    end
  end

  @doc """
  Propagates the beam through the map from the starting position.

  Returns the path of the beam.
  """
  def propagate_beam(map, start \\ {:right, -1, 0}) do
    propagate_beam(map, [start], MapSet.new())
  end

  defp propagate_beam(map, heads, path) do
    new_heads =
      Enum.flat_map(heads, fn head ->
        new_head = next_position(head)
        new_tile = tile_at(map, new_head)

        propagate_head(new_tile, new_head)
      end)
      |> Enum.reject(fn head -> MapSet.member?(path, head) end)

    new_path =
      Enum.reduce(new_heads, path, fn head, path ->
        MapSet.put(path, head)
      end)

    if new_heads == [] do
      new_path
    else
      propagate_beam(map, new_heads, new_path)
    end
  end

  defp propagate_head(nil, _), do: []
  defp propagate_head(".", head), do: [head]
  defp propagate_head("/", {:up, x, y}), do: [{:right, x, y}]
  defp propagate_head("/", {:down, x, y}), do: [{:left, x, y}]
  defp propagate_head("/", {:right, x, y}), do: [{:up, x, y}]
  defp propagate_head("/", {:left, x, y}), do: [{:down, x, y}]
  defp propagate_head("\\", {:up, x, y}), do: [{:left, x, y}]
  defp propagate_head("\\", {:down, x, y}), do: [{:right, x, y}]
  defp propagate_head("\\", {:right, x, y}), do: [{:down, x, y}]
  defp propagate_head("\\", {:left, x, y}), do: [{:up, x, y}]
  defp propagate_head("-", {:up, x, y}), do: [{:left, x, y}, {:right, x, y}]
  defp propagate_head("-", {:down, x, y}), do: [{:left, x, y}, {:right, x, y}]
  defp propagate_head("-", head), do: [head]
  defp propagate_head("|", {:right, x, y}), do: [{:up, x, y}, {:down, x, y}]
  defp propagate_head("|", {:left, x, y}), do: [{:up, x, y}, {:down, x, y}]
  defp propagate_head("|", head), do: [head]

  @doc """
  Count the number of energized tiles in the beam path.
  """
  def count_energized(beam_path) do
    beam_path
    |> Enum.uniq_by(fn {_, x, y} -> {x, y} end)
    |> Enum.count()
  end

  @doc """
  Find the maximum number of energized tiles for all the possible incoming beams.
  """
  def find_maximum_energized(map) do
    max_rows =
      0..(length(map) - 1)
      |> Enum.flat_map(fn y ->
        [
          propagate_beam(map, {:right, -1, y})
          |> count_energized(),
          propagate_beam(map, {:left, String.length(hd(map)), y})
          |> count_energized()
        ]
      end)
      |> Enum.max()

    max_cols =
      0..(String.length(hd(map)) - 1)
      |> Enum.flat_map(fn x ->
        [
          propagate_beam(map, {:down, x, -1})
          |> count_energized(),
          propagate_beam(map, {:up, x, length(map)})
          |> count_energized()
        ]
      end)
      |> Enum.max()

    max(max_rows, max_cols)
  end

  @doc """
  Draw the beam path on the map.
  """
  def draw_beam_path(map, beam_path) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn {c, x} ->
        cond do
          c == ?| -> "|"
          c == ?- -> "-"
          c == ?/ -> "/"
          c == ?\\ -> "\\"
          MapSet.member?(beam_path, {:right, x, y}) -> ">"
          MapSet.member?(beam_path, {:left, x, y}) -> "<"
          MapSet.member?(beam_path, {:up, x, y}) -> "^"
          MapSet.member?(beam_path, {:down, x, y}) -> "v"
          true -> c
        end
      end)
      |> to_string()
    end)
    |> Enum.join("\n")
  end
end
