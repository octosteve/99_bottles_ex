defmodule BottleNumber do
  defstruct ~w(quantity container successor action number)a

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{quantity: quantity, container: container}) do
      "#{quantity} #{container}"
    end
  end

  def new(0) do
    compose([&base_bottle_number/1, &bottle_0/1]).(0)
  end

  def new(1) do
    compose([&base_bottle_number/1, &bottle_1/1]).(1)
  end

  def new(6) do
    compose([&base_bottle_number/1, &bottle_6/1]).(6)
  end

  def new(bottle_number), do: compose([&base_bottle_number/1]).(bottle_number)
  def successor(%__MODULE__{successor: successor}), do: new(successor)

  def compose(bottle_builders) do
    fn number ->
      bottle_builders
      |> Enum.reduce(__struct__(number: number), fn builder, struct ->
        struct
        |> builder.()
      end)
    end
  end

  def base_bottle_number(%__MODULE__{number: number} = struct) do
    struct
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
