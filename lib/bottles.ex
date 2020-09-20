defmodule BottleNumber do
  defstruct ~w(quantity container successor action number)a
  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{quantity: quantity, container: container}) do
      "#{quantity} #{container}"
    end
  end
  def new(0), do: new(0, bottle_0_builder())
  def new(1), do: new(1, bottle_1_builder())
  def new(6), do: new(6, bottle_6_builder())
  def new(bottle_number), do: new(bottle_number, bottle_number_builder())
  def successor(%__MODULE__{successor: successor}), do: new(successor)

  def new(number, builder) do
    __struct__(number: number)
    |> Map.put(:quantity, builder.quantity.(number))
    |> Map.put(:container, builder.container.(number))
    |> Map.put(:successor, builder.successor.(number))
    |> Map.put(:action, builder.action.(number))
  end

  def bottle_number_builder do
    %{
      quantity: &(&1 |> to_string),
      container: fn _ -> "bottles" end,
      successor: &(&1 - 1),
      action: fn _ -> "Take one down and pass it around" end
    }
  end

  def bottle_0_builder do
    Map.merge(bottle_number_builder(), %{
      quantity: fn 0 -> "no more" end,
      successor: fn _ -> 99 end,
      action: fn _ -> "Go to the store and buy some more" end
    })
  end

  def bottle_1_builder do
    Map.merge(bottle_number_builder(), %{
      container: fn _ -> "bottle" end,
      action: fn _ -> "Take it down and pass it around" end
    })
  end

  def bottle_6_builder do
    Map.merge(bottle_number_builder(), %{
      quantity: fn _ -> "1" end,
      container: fn _ -> "six-pack" end
    })
  end
end

defmodule Bottles do
  def verse(number) do
    current_bottle = BottleNumber.new(number)
    next_bottle = BottleNumber.successor(current_bottle)

    String.capitalize(
      "#{current_bottle} of beer on the wall, "
    ) <>
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
