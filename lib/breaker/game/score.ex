defmodule Breaker.Game.Score do
  defstruct [:red, :white]

  def new(guess, answer) do
    misses = length(guess -- answer)
    list = Enum.zip(guess, answer)
    red = Enum.count(list, fn {item1, item2} -> item1 == item2 end)
    white = 4 - (misses + red)
    %__MODULE__{red: red, white: white}
  end

  def show(score) do
    "#{String.duplicate("R", score.red)}#{String.duplicate("W", score.white)}"
  end
end
