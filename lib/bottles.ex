defmodule BottleNumber do
  defstruct ~w(quantity container successor action number)a

  defimpl String.Chars, for: __MODULE__ do
    def to_string(%{quantity: quantity, container: container}) do
      "#{quantity} #{container}"
    end
  end

  def new(number) do
    __struct__(number: number)
    |> set_defaults
    |> merge_overrides
  end

  def successor(%__MODULE__{successor: successor}), do: new(successor)

  def set_defaults(%__MODULE__{number: number} = struct) do
    %{
      struct
      | quantity: to_string(number),
        container: "bottles",
        successor: number - 1,
        action: "Take one down and pass it around"
    }
  end

  def merge_overrides(%__MODULE__{number: 0} = struct) do
    %{struct | quantity: "no more", successor: 99, action: "Go to the store and buy some more"}
  end

  def merge_overrides(%__MODULE__{number: 1} = struct) do
    %{struct | container: "bottle", action: "Take it down and pass it around"}
  end

  def merge_overrides(%__MODULE__{number: 6} = struct) do
    %{struct | quantity: "1", container: "six-pack"}
  end

  def merge_overrides(struct), do: struct
end

defmodule Bottles do
  defmodule Bottles.Verse do
    defstruct ~w(verse_number current_bottle next_bottle adapter)a

    def new(verse_number, adapter) do
      struct!(__MODULE__, verse_number: verse_number, adapter: adapter)
      |> load_current_bottle
      |> load_next_bottle
    end

    def load_current_bottle(%__MODULE__{verse_number: verse_number, adapter: adapter} = struct) do
      %{struct | current_bottle: adapter.new(verse_number)}
    end

    def load_next_bottle(%__MODULE__{current_bottle: current_bottle, adapter: adapter} = struct) do
      %{struct | next_bottle: adapter.successor(current_bottle)}
    end

    def to_string(%__MODULE__{current_bottle: current_bottle, next_bottle: next_bottle}) do
      String.capitalize("#{current_bottle} of beer on the wall, ") <>
        "#{current_bottle} of beer.\n" <>
        "#{current_bottle.action}, " <>
        "#{next_bottle} of beer on the wall.\n"
    end
  end

  def verse(number, adapter \\ BottleNumber) do
    number
    |> Bottles.Verse.new(adapter)
    |> Bottles.Verse.to_string()
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
