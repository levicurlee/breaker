defmodule Breaker.Game do
  alias Breaker.Game.Row
  defstruct answer: nil, rows: []

  def new(answer) do
    %__MODULE__{answer: answer}
  end

  def new do
    %__MODULE__{answer: random_answer()}
  end

  def take_turn(game, guess) do
    row = Row.new(guess, game.answer)
    %{game | rows: [row | game.rows]}
  end

  def show(game) do
    """
    #{if status(game) == :won, do: Enum.join(game.answer, " "), else: "? ? ? ?"} | #{status(game)}
    #{show_rows(game.rows)}
    """
  end

  def status(game) do
    case game.rows do
      [%Row{score: %{red: 4}} | _] -> :won
      rows when length(rows) >= 10 -> :lost
      _ -> :playing
    end
  end

  defp show_rows(rows) do
    Enum.map_join(rows, "\n", &Row.show/1)
  end

  defp random_answer do
    1..8
    |> Enum.shuffle()
    |> Enum.take(4)
  end
end
