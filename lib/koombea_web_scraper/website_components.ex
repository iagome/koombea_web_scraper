defmodule KoombeaWebScraper.WebsiteComponents do
  @moduledoc """
  Context for the website components schema
  """

  alias KoombeaWebScraper.Repo
  alias KoombeaWebScraper.Websites.WebsiteComponent

  @spec create(list(), integer()) :: {non_neg_integer(), nil | list()}
  def create(attrs, website_id) do
    built_attrs = Enum.map(attrs, &Map.put(&1, :website_id, website_id))

    Repo.insert_all(WebsiteComponent, built_attrs)
  end
end
