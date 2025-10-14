defmodule Breaker.Server do
  use GenServer
  alias Breaker.Game

  # Client API

  def child_spec(name) do
    %{id: name, start: {Breaker.Server, :start_link, [name]}}
  end

  def start_link(name) when is_atom(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def start_link(answer) when is_list(answer) do
    GenServer.start_link(__MODULE__, answer, name: __MODULE__)
  end

  def crash(pid \\ __MODULE__) do
    GenServer.cast(pid, :crash)
  end

  def take_turn(pid \\ __MODULE__, guess) do
    GenServer.call(pid, {:take_turn, guess})
    |> IO.puts()
  end

  def show(pid \\ __MODULE__) do
    GenServer.call(pid, :show)
  end

  def restart(pid \\ __MODULE__, answer \\ nil) do
    GenServer.call(pid, {:restart, answer})
  end

  # Server Callbacks

  @impl GenServer
  def init(name) when is_atom(name) do
    IO.puts("Starting new game for #{name}...")
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
