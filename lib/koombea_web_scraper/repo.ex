defmodule KoombeaWebScraper.Repo do
  use Ecto.Repo,
    otp_app: :koombea_web_scraper,
    adapter: Ecto.Adapters.Postgres
end
