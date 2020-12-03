defmodule Bottles do
  def verse(verse_number) do
    String.capitalize(
      "#{quantity(verse_number)} #{container(verse_number)} of beer on the wall, "
    ) <>
      "#{quantity(verse_number)} #{container(verse_number)} of beer.\n" <>
      action(verse_number) <>
      "#{quantity(successor(verse_number))} #{container(successor(verse_number))} of beer on the wall.\n"
  end

  def verses(start_verse, end_verse) do
    start_verse..end_verse
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  def song do
    verses(99, 0)
  end

  defp container(1) do
    "bottle"
  end

  defp container(_number) do
    "bottles"
  end

  defp quantity(0) do
    "no more"
  end

  defp quantity(number) do
    number
  end

  defp pronoun(1) do
    "it"
  end

  defp pronoun(_) do
    "one"
  end

  defp action(0) do
    "Go to the store and buy some more, "
  end

  defp action(verse_number) do
    "Take #{pronoun(verse_number)} down and pass it around, "
  end

  defp successor(0) do
    99
  end

  defp successor(verse_number) do
    verse_number - 1
  end
end
