defmodule Day01.Trebuchet do
  @moduledoc """
  You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").

  As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.
  """

  @doc """
  Adds the calibration values of each line in `input_stream`.
  """
  def calibration_value_sum(input_stream) do
    input_stream
    |> Stream.map(&calibration_value/1)
    |> Enum.sum()
  end

  @doc """
  Adds the naive calibration values of each line in `input_stream`.
  """
  def naive_calibration_value_sum(input_stream) do
    input_stream
    |> Stream.map(&naive_calibration_value/1)
    |> Enum.sum()
  end

  @doc """
  On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.
   
  It looks like some of the digits are actually spelled out with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".

  ## Examples

      iex> Day01.Trebuchet.calibration_value("two1nine")
      29
  """
  def calibration_value(input) do
    input
    |> replace_digits()
    |> naive_calibration_value()
  end

  @doc """
  On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

  ## Examples

      iex> Day01.Trebuchet.naive_calibration_value("1abc2")
      12
  """
  def naive_calibration_value(input) do
    digits = String.replace(input, ~r/[^\d]/, "")

    {value, ""} =
      (String.first(digits) <> String.last(digits))
      |> Integer.parse(10)

    value
  end

  defp replace_digits(input) do
    input
    |> replace_first_digit()
    |> replace_last_digit()
  end

  defp replace_first_digit(input) do
    case Regex.run(~r/one|two|three|four|five|six|seven|eight|nine/, input) do
      nil -> input
      [digit] -> String.replace(input, digit, string_to_digit(digit))
    end
  end

  defp replace_last_digit(input) do
    case Regex.run(~r/eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/, String.reverse(input)) do
      nil ->
        input

      [rev_digit] ->
        digit = String.reverse(rev_digit)
        String.replace(input, digit, string_to_digit(digit))
    end
  end

  defp string_to_digit("one"), do: "1"
  defp string_to_digit("two"), do: "2"
  defp string_to_digit("three"), do: "3"
  defp string_to_digit("four"), do: "4"
  defp string_to_digit("five"), do: "5"
  defp string_to_digit("six"), do: "6"
  defp string_to_digit("seven"), do: "7"
  defp string_to_digit("eight"), do: "8"
  defp string_to_digit("nine"), do: "9"
end
