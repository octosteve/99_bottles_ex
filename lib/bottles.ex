defmodule Bottles do
  def verse(0) do
    "No more bottles of beer on the wall, " <>
      "no more bottles of beer.\n" <>
      "Go to the store and buy some more, " <>
      "99 bottles of beer on the wall.\n"
  end

  def verse(1) do
    "1 bottle of beer on the wall, " <>
      "1 bottle of beer.\n" <>
      "Take it down and pass it around, " <>
      "no more bottles of beer on the wall.\n"
  end

  def verse(verse_number) do
    "#{verse_number} #{container(verse_number)} of beer on the wall, " <>
      "#{verse_number} bottles of beer.\n" <>
      "Take one down and pass it around, " <>
      "#{verse_number - 1} #{container(verse_number - 1)} of beer on the wall.\n"
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
end
