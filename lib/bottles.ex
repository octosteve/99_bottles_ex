defmodule BottleNumber do
  defstruct ~w(quantity container successor action number)a

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{quantity: quantity, container: container}) do
      "#{quantity} #{container}"
    end
  end

  def new(bottle_number) do
    struct = build(bottle_number)

    try do
      apply(__MODULE__, String.to_atom("bottle_#{bottle_number}"), [struct])
    rescue
      UndefinedFunctionError ->
        struct
    end
  end

  def successor(%__MODULE__{successor: successor}), do: new(successor)

  def build(number) do
    __struct__(number: number)
    |> Map.put(:quantity, number |> to_string)
    |> Map.put(:container, "bottles")
    |> Map.put(:successor, number - 1)
    |> Map.put(:action, "Take one down and pass it around")
  end

  def bottle_0(%__MODULE__{} = struct) do
    struct
    |> Map.put(:quantity, "no more")
    |> Map.put(:successor, 99)
    |> Map.put(:action, "Go to the store and buy some more")
  end

  def bottle_1(%__MODULE__{} = struct) do
    struct
    |> Map.put(:container, "bottle")
    |> Map.put(:action, "Take it down and pass it around")
  end

  def bottle_6(%__MODULE__{} = struct) do
    struct
    |> Map.put(:quantity, "1")
    |> Map.put(:container, "six-pack")
  end
end

defmodule Bottles do
  def verse(number, bottle_number \\ BottleNumber) do
    current_bottle = bottle_number.new(number)
    next_bottle = bottle_number.successor(current_bottle)

    String.capitalize("#{current_bottle} of beer on the wall, ") <>
      "#{current_bottle} of beer.\n" <>
      "#{current_bottle.action}, " <>
      "#{next_bottle} of beer on the wall.\n"
  end

  def verses(upper, lower) do
    upper..lower
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  def song do
    verses(99, 0)
  end
end
