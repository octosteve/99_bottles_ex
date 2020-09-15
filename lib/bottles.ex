defmodule BottleNumber do
  defstruct [:number, :quantity, :next_quantity, :pronoun, :container, :next_container, :action]

  def new(number) do
    %__MODULE__{number: number}
    |> add_quantity
    |> add_next_quantity
    |> add_pronoun
    |> add_container
    |> add_next_container
    |> add_action
  end

  def add_quantity(%__MODULE__{number: number} = struct) do
    put_in(struct.quantity, number |> quantity |> to_string)
  end

  def add_next_quantity(%__MODULE__{number: number} = struct) do
    put_in(struct.next_quantity, number |> next_quantity)
  end

  def add_pronoun(%__MODULE__{number: number} = struct) do
    put_in(struct.pronoun, number |> pronoun)
  end

  def add_container(%__MODULE__{number: number} = struct) do
    put_in(struct.container, number |> container)
  end

  def add_next_container(%__MODULE__{number: number} = struct) do
    put_in(struct.next_container, number |> next_container)
  end

  def add_action(%__MODULE__{number: number} = struct) do
    put_in(struct.action, number |> action)
  end

  def action(0), do: "Go to the store and buy some more"
  def action(number), do: "Take #{number |> pronoun} down and pass it around"

  def next_verse(0), do: 99
  def next_verse(verse_number), do: verse_number - 1

  def container(1), do: "bottle"
  def container(_number), do: "bottles"

  def quantity(0), do: "no more"
  def quantity(number), do: number |> to_string

  def pronoun(1), do: "it"
  def pronoun(_number), do: "one"

  def next_quantity(number) do
    number
    |> next_verse
    |> quantity
  end

  def next_container(number) do
    number
    |> next_verse
    |> container
  end
end

defmodule Bottles do
  def verse(verse_number) do
    bottle_number = BottleNumber.new(verse_number)

    "#{bottle_number.quantity |> String.capitalize()} #{bottle_number.container} of beer on the wall, " <>
      "#{bottle_number.quantity} #{bottle_number.container} of beer.\n" <>
      "#{bottle_number.action}, " <>
      "#{bottle_number.next_quantity} #{bottle_number.next_container} of beer on the wall.\n"
  end

  def verses(start_verse, end_verse) do
    start_verse..end_verse
    |> Enum.map(&verse(&1))
    |> Enum.join("\n")
  end

  def song do
    verses(99, 0)
  end
end
