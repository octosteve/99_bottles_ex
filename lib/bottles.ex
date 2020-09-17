defmodule ABottleNumber do
  defmacro __using__(_opts) do
    quote do
      defstruct [:number, :quantity, :pronoun, :container, :action]
      @behaviour ABottleNumber
    end
  end

  @callback action() :: String.t()
  @callback container() :: String.t()
  @callback quantity(number :: Integer.t()) :: String.t()
end

defmodule BottleNumber do
  use ABottleNumber

  def new(number), do: %__MODULE__{number: number}
  def action, do: "Take one down and pass it around"
  def container, do: "bottles"
  def quantity(number), do: to_string(number)
end

defmodule BottleNumber0 do
  use ABottleNumber

  def new, do: %__MODULE__{number: 0}
  def action, do: "Go to the store and buy some more"
  def container, do: "bottles"
  def quantity(_number), do: "no more"
end

defmodule BottleNumber1 do
  use ABottleNumber

  def new, do: %__MODULE__{number: 1}
  def action, do: "Take it down and pass it around"
  def container, do: "bottle"
  def quantity(_number), do: "1"
end

defmodule BottleNumberBuilder do
  def new(number) do
    module = module_for(number)

    number
    |> add_quantity(module)
    |> add_container(module)
    |> add_action(module)
  end

  def add_quantity(%{number: number} = struct, module) do
    put_in(struct.quantity, module.quantity(number))
  end

  def add_container(struct, module) do
    put_in(struct.container, module.container)
  end

  def add_action(struct, module) do
    put_in(struct.action, module.action)
  end

  defp module_for(struct), do: struct.__struct__
end

defmodule BottleNumberFetcher do
  def new(0) do
    BottleNumber0.new()
    |> BottleNumberBuilder.new()
  end

  def new(1) do
    BottleNumber1.new()
    |> BottleNumberBuilder.new()
  end

  def new(number) do
    number
    |> BottleNumber.new()
    |> BottleNumberBuilder.new()
  end

  def next(%BottleNumber0{}), do: new(99)
  def next(%{number: number}), do: new(number - 1)
end

defimpl String.Chars, for: [BottleNumber, BottleNumber0, BottleNumber1] do
  def to_string(%{quantity: quantity, container: container}) do
    "#{quantity} #{container}"
  end
end

defmodule Bottles do
  def verse(verse_number) do
    bottle_number = BottleNumberFetcher.new(verse_number)

    next_number = BottleNumberFetcher.next(bottle_number)

    String.capitalize("#{bottle_number} of beer on the wall, ") <>
      "#{bottle_number} of beer.\n" <>
      "#{bottle_number.action}, " <>
      "#{next_number} of beer on the wall.\n"
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
