defmodule Breaker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting application...")

      children = [
  # Start a dynamic supervisor for game servers
  #{DynamicSupervisor, strategy: :one_for_one, name: :dsup},
  {Breaker.Server, :batman},
  {Breaker.Server, :flash},
  {Breaker.Server, :hulk},
  {Breaker.Server, :iron_man},
  {Breaker.Server, :superman},
]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: :sup]
    Supervisor.start_link(children, opts)
  end
end
