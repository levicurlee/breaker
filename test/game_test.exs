defmodule Breaker.GameTest do
  use ExUnit.Case
  alias Breaker.Game
  alias Breaker.Game.Row

  describe "new/1" do
    test "creates a new game with a given answer" do
      game = Game.new([1, 2, 3, 4])
      assert game.answer == [1, 2, 3, 4]
      assert game.rows == []
    end
  end

  describe "new/0" do
    test "creates a new game with a random answer" do
      game = Game.new()
      assert length(game.answer) == 4
      assert Enum.all?(game.answer, &(&1 in 1..8))
      assert Enum.uniq(game.answer) == game.answer
      assert game.rows == []
    end
  end

  describe "take_turn/2" do
    test "adds a new row to the game" do
      game = Game.new([1, 2, 3, 4])
      guess = [1, 2, 3, 4]
      game2 = Game.take_turn(game, guess)
      assert length(game2.rows) == 1
      assert hd(game2.rows).guess == guess
    end
  end

  describe "status/1" do
    test "returns :won if the first row has a perfect score" do
      row = %Row{guess: [1, 2, 3, 4], score: %Breaker.Game.Score{red: 4, white: 0}}
      game = %Game{answer: [1, 2, 3, 4], rows: [row]}
      assert Game.status(game) == :won
    end

    test "returns :lost if there are 10 or more rows" do
      row = %Row{guess: [0, 0, 0, 0], score: %Breaker.Game.Score{red: 0, white: 0}}
      rows = for _ <- 1..10, do: row
      game = %Game{answer: [1, 2, 3, 4], rows: rows}
      assert Game.status(game) == :lost
    end

    test "returns :playing otherwise" do
      game = %Game{answer: [1, 2, 3, 4], rows: []}
      assert Game.status(game) == :playing
    end
  end

  describe "show/1" do
    test "shows the answer if won" do
      row = %Row{guess: [1, 2, 3, 4], score: %Breaker.Game.Score{red: 4, white: 0}}
      game = %Game{answer: [1, 2, 3, 4], rows: [row]}
      output = Game.show(game)
      assert output =~ "1 2 3 4 | won"
    end

    test "hides the answer if not won" do
      game = %Game{answer: [1, 2, 3, 4], rows: []}
      output = Game.show(game)
      assert output =~ "? ? ? ? | playing"
    end
  end
end
