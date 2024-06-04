Ecto.Adapters.SQL.Sandbox.mode(KoombeaWebScraper.Repo, :manual)
ExUnit.start(capture_log: true)

Mimic.copy(Crawly)
Mimic.copy(KoombeaWebScraper.UrlsScraper)
