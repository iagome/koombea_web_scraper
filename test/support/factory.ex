defmodule KoombeaWebScraper.Factory do
  @moduledoc """
  Responsible for concentrating all factories in one module, so we don't have to import each factory individually
  """

  use ExMachina.Ecto, repo: KoombeaWebScraper.Repo

  use KoombeaWebScraper.WebsiteComponentFactory
  use KoombeaWebScraper.WebsiteFactory
end
