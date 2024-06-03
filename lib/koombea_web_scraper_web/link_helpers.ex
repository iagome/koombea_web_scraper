defmodule KoombeaWebScraperWeb.LinkHelpers do
  @moduledoc """
  Helper to build links for the HTML
  """

  alias KoombeaWebScraper.Websites.Website

  @doc """
  Create or get a new URL to redirect pages

  ## Examples

      iex> create_target_url(%Website{id: 123})
      "/details/123"

      iex> create_target_url(%{url: "https://google.com"})
      "https://google.com"
  """
  @spec create_target_url(Website.t() | map()) :: String.t()
  def create_target_url(%Website{} = website), do: "/details/#{website.id}"

  def create_target_url(website), do: website.url
end
