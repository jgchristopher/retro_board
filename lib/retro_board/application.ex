defmodule RetroBoard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RetroBoardWeb.Telemetry,
      # Start the Ecto repository
      RetroBoard.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: RetroBoard.PubSub},
      # Start Finch
      {Finch, name: RetroBoard.Finch},
      # Start the Endpoint (http/https)
      RetroBoardWeb.Endpoint
      # Start a worker by calling: RetroBoard.Worker.start_link(arg)
      # {RetroBoard.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RetroBoard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RetroBoardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
