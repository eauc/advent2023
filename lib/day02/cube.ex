defmodule Day02.Cube do
  @moduledoc """
  As you walk, the Elf shows you a small bag and some cubes which are either red, green, or blue. Each time you play this game, he will hide a secret number of cubes of each color in the bag, and your goal is to figure out information about the number of cubes.

  To get information, once a bag has been loaded with cubes, the Elf will reach into the bag, grab a handful of random cubes, show them to you, and then put them back in the bag. He'll do this a few times per game.

  You play several games and record the information from each game (your puzzle input). Each game is listed with its ID number (like the 11 in Game 11: ...) followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like 3 red, 5 green, 4 blue).

  For example, the record of a few games might look like this:
  ```
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  ```
  In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.

  In each game you played, what is the fewest number of cubes of each color that could have been in the bag to make the game possible?

  Again consider the example games from earlier:
  ```
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  ```
  - In game 1, the game could have been played with as few as 4 red, 2 green, and 6 blue cubes. If any color had even one fewer cube, the game would have been impossible.
  - Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue cubes.
  - Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
  - Game 4 required at least 14 red, 3 green, and 15 blue cubes.
  - Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.

  The power of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together. The power of the minimum set of cubes in game 1 is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively.
  """

  @doc """
  Parse the game records stream into a list of games.
  """
  def parse_games(lines_stream) do
    lines_stream
    |> Enum.map(&parse_game/1)
  end

  @doc """
  A game is possible if no sample show more cube of any color as there are cubes of that color in the bag.
  """
  def game_possible?(game, total_cubes) do
    game.samples
    |> Enum.all?(fn sample ->
      sample
      |> Enum.all?(fn {color, count} -> count <= Map.get(total_cubes, color, 0) end)
    end)
  end

  @doc """
  Get the minimum bag of cubes required to play a game.
  """
  def minimum_bag(game) do
    %{
      blue:
        game.samples
        |> Stream.map(&Map.get(&1, :blue, 0))
        |> Enum.max(),
      green:
        game.samples
        |> Stream.map(&Map.get(&1, :green, 0))
        |> Enum.max(),
      red:
        game.samples
        |> Stream.map(&Map.get(&1, :red, 0))
        |> Enum.max()
    }
  end

  @doc """
  The power of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together.
  """
  def cubes_set_power(cubes_set) do
    cubes_set
    |> Map.values()
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp parse_game(line) do
    [_, id_str, samples_str] = Regex.run(~r/^Game (\d+): (.+)$/, line)

    %{
      id: String.to_integer(id_str),
      samples: parse_game_samples(samples_str)
    }
  end

  defp parse_game_samples(samples_str) do
    samples_str
    |> String.split("; ")
    |> Enum.map(&parse_game_sample/1)
  end

  defp parse_game_sample(sample_str) do
    sample_str
    |> String.split(", ")
    |> Enum.map(fn str ->
      [count, color] = String.split(str, " ")
      {String.to_atom(color), String.to_integer(count)}
    end)
    |> Enum.into(%{})
  end
end
