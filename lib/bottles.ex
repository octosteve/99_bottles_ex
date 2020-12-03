defmodule Bottles do
  def verse(0) do
    "No more bottles of beer on the wall, " <>
      "no more bottles of beer.\n" <>
      "Go to the store and buy some more, " <>
      "99 bottles of beer on the wall.\n"
  end

  def verse(verse_number) do
    "#{verse_number} #{container(verse_number)} of beer on the wall, " <>
      "#{verse_number} #{container(verse_number)} of beer.\n" <>
      "Take #{pronoun(verse_number)} down and pass it around, " <>
      "#{quantity(verse_number - 1)} #{container(verse_number - 1)} of beer on the wall.\n"
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
end
