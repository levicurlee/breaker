defmodule Breaker.Server do
  use GenServer
  alias Breaker.Game

  # Client API

  def start_link(answer \\ nil) do
    GenServer.start_link(__MODULE__, answer, name: __MODULE__)
  end

  def crash do
    GenServer.cast(__MODULE__, :crash)
  end

  def take_turn(guess) do
    GenServer.call(__MODULE__, {:take_turn, guess})
    |> IO.puts()
  end

  def show do
    GenServer.call(__MODULE__, :show)
  end

  def restart(answer \\ nil) do
    GenServer.call(__MODULE__, {:restart, answer})
  end

  # Server Callbacks

  @impl GenServer
  def init(nil) do
    IO.puts("Starting new game...")
    {:ok, Game.new()}
  end

  def init(answer) do
    {:ok, Game.new(answer)}
  end

  @impl GenServer
  def handle_cast(:crash, _state) do
    raise "BOOM!!"
  end

  @impl GenServer
  def handle_call({:take_turn, guess}, _from, state) do
    game = Game.take_turn(state, guess)

    case Game.status(game) do
      :won ->
        IO.puts("Congratulations! You've won!\nStarting new game...")
        {:reply, Game.show(game), Game.new()}

      :lost ->
        IO.puts(
          "Game over! You've lost. The correct answer was #{Enum.join(game.answer, " ")}.\nStarting new game..."
        )

        {:reply, Game.show(game), Game.new()}

      _ ->
        {:reply, Game.show(game), game}
    end
  end

  def handle_call(:show, _from, state) do
    {:reply, Game.show(state), state}
  end

  def handle_call({:restart, answer}, _from, _state) do
    case answer do
      nil -> {:reply, :ok, Game.new()}
      _ -> {:reply, :ok, Game.new(answer)}
    end
  end
end
