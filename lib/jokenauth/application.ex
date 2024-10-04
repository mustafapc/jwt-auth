defmodule Jokenauth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JokenauthWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:jokenauth, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jokenauth.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Jokenauth.Finch},
      # Start a worker by calling: Jokenauth.Worker.start_link(arg)
      # {Jokenauth.Worker, arg},
      # Start to serve requests, typically the last entry
      JokenauthWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jokenauth.Supervisor]
    Supervisor.start_link(children, opts)
    System.shell("surreal.exe start -A --user root --pass root")
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JokenauthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
