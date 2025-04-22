defmodule Day11.Galaxies do
  def parse_galaxies(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  @doc """
  Returns the positions of the galaxies as `{row, col}` tuples
  """
  def galaxy_positions(galaxies) do
    galaxies
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} ->
      line
      |> Enum.with_index()
      |> Enum.filter(fn {c, _} -> c == ?# end)
      |> Enum.map(fn {_, col} -> {row, col} end)
    end)
  end

  @doc """
  Return all possibles unique pairs of galaxies.
  """
  def galaxies_pairs(galaxies, pairs \\ []) do
    case galaxies do
      [] ->
        pairs

      [_] ->
        pairs

      [galaxy | rest] ->
        galaxies_pairs(
          rest,
          Enum.map(rest, &{galaxy, &1}) ++ pairs
        )
    end
  end

  @doc """
  Finds the columns and rows indices subject to expansion (ie. not containing a galaxy).
  """
  def find_expansion_spaces(galaxies) do
    rows =
      galaxies
      |> Enum.with_index()
      |> Enum.reject(fn {line, _} ->
        Enum.find(line, fn c -> c == ?# end)
      end)
      |> Enum.map(fn {_, row} -> row end)

    cols =
      0..(Enum.count(hd(galaxies)) - 1)
      |> Enum.reject(fn col ->
        galaxies
        |> Enum.find(fn line -> Enum.at(line, col) == ?# end)
      end)

    %{rows: rows, cols: cols}
  end

  @doc """
  Returns the shortest distance between two galaxies.

  The distance is just the absolute difference between the positions of the 2 galaxies.
  Takes into account the universe expansion, by adding the expansion factor for each column or row marked as expansion space between the 2 galaxies.
  """
  def shortest_distance(galaxies_pair, expansion_spaces, expansion_factor \\ 2) do
    {a, b} = galaxies_pair
    {arow, acol} = a
    {brow, bcol} = b

    col_rng = min(acol, bcol)..max(acol, bcol)
    row_rng = min(arow, brow)..max(arow, brow)

    expanded_cols = Enum.filter(expansion_spaces.cols, fn col -> col in col_rng end)
    expanded_rows = Enum.filter(expansion_spaces.rows, fn row -> row in row_rng end)

    Range.size(col_rng) +
      Range.size(row_rng) +
      (expansion_factor - 1) * Enum.count(expanded_cols) +
      (expansion_factor - 1) * Enum.count(expanded_rows) - 2
  end
end
