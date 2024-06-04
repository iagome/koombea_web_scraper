defmodule KoombeaWebScraper.Websites do
  @moduledoc """
  Context for the websites schema
  """
  import Ecto.Query

  alias KoombeaWebScraper.Repo
  alias KoombeaWebScraper.UrlsScraper
  alias KoombeaWebScraper.WebsiteComponents
  alias KoombeaWebScraper.Websites.Website

  @doc """
  Scrapes a website, creates it and its components on the database

  ## Examples

      iex> create("https://google.com", 123)
      :ok
  """
  @spec create(String.t(), integer()) :: :ok | {:error, String.t()}
  def create(url, user_id) do
    with {:ok, page_title, components} <- UrlsScraper.scrape_and_parse_url(url),
         sanitized_components <- sanitize_website_components(components, url),
         attrs <- build_attrs(url, user_id, page_title, length(sanitized_components)),
         {:ok, website} <- create_website(attrs),
         {_created_components, nil} <-
           WebsiteComponents.batch_create(sanitized_components, website.id) do
      {:ok, website}
    end
  end

  defp sanitize_website_components(components, base_url) do
    components
    |> Enum.map(&sanitize_component(&1, base_url))
    |> Enum.reject(&Enum.empty?(&1))
  end

  defp sanitize_component(%{url: ""}, _base_url), do: []
  defp sanitize_component(%{name: ""}, _base_url), do: []

  defp sanitize_component(%{url: url} = component, base_url) do
    cond do
      String.starts_with?(url, "/") ->
        %{component | url: base_url <> url}

      String.starts_with?(url, "http") ->
        component

      true ->
        []
    end
  end

  defp build_attrs(url, user_id, page_title, total_links) do
    %{
      url: url,
      user_id: user_id,
      name: page_title,
      total_links: total_links
    }
  end

  defp create_website(attrs) do
    %Website{}
    |> Website.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Get all websites by an user ID

  ## Examples

      iex> get_by_user_id(123)
      [%Website{}, %Website{}]

      iex> get_by_user_id(9999)
      []
  """
  @spec get_by_user_id(integer()) :: [Website.t()] | []
  def get_by_user_id(user_id) do
    Website
    |> where([w], w.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Get a website by its ID

  ## Examples

      iex> get(123)
      %Website{}

      iex> get(9999)
      nil
  """
  @spec get(integer()) :: Website.t() | nil
  def get(id) do
    Repo.get(Website, id)
  end
end
