defmodule Breaker do
  @moduledoc """
  Documentation for `Breaker`.
  """

  @doc """
  Use a dynamic supervisor to start a new game server with a unique name.
  The name must be an atom.

  """
  def new(name) do
    spec = {Breaker.Server, name}

    DynamicSupervisor.start_child(:dsup, spec)
  end

  def take_turn(name, guess) when is_atom(name) do
    Breaker.Server.take_turn(name, guess)
  end
end
