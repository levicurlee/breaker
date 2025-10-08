defmodule Breaker.Game.Row do
  alias Breaker.Game.Score

  defstruct [:guess, :score]

  def new(guess, answer) do
    %__MODULE__{guess: guess, score: Score.new(guess, answer)}
  end

  def show(row) do
    "#{Enum.join(row.guess, " ")} | #{Score.show(row.score)}"
  end
end
