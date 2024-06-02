defmodule KoombeaWebScraper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KoombeaWebScraperWeb.Telemetry,
      KoombeaWebScraper.Repo,
      {DNSCluster, query: Application.get_env(:koombea_web_scraper, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KoombeaWebScraper.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: KoombeaWebScraper.Finch},
      # Start a worker by calling: KoombeaWebScraper.Worker.start_link(arg)
      # {KoombeaWebScraper.Worker, arg},
      # Start to serve requests, typically the last entry
      KoombeaWebScraperWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KoombeaWebScraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KoombeaWebScraperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
