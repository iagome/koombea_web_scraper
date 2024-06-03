defmodule KoombeaWebScraper.WebsiteComponents do
  @moduledoc """
  Context for the website components schema
  """
  import Ecto.Query

  alias KoombeaWebScraper.Repo
  alias KoombeaWebScraper.Websites.WebsiteComponent

  @doc """
  Batch create for the website components

  ## Examples

      iex> batch_create([%{name: "Link 1", "https://link1.com"}, %{name: "Link 2", "https://link2.com"}], 123)
      {2, nil}
  """
  @spec batch_create(list(), integer()) :: {non_neg_integer(), nil | list()}
  def batch_create(attrs, website_id) do
    built_attrs =
      Enum.map(attrs, fn attr ->
        attr
        |> Map.put(:website_id, website_id)
        |> Map.put(:inserted_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
        |> Map.put(:updated_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
      end)

    Repo.insert_all(WebsiteComponent, built_attrs)
  end

  @doc """
  Get all website components by a website ID

  ## Examples

      iex> get_by_website_id(123)
      [%WebsiteComponent{}, %WebsiteComponent{}]

      iex> get_by_website_id(9999)
      []
  """
  @spec get_by_website_id(integer()) :: [WebsiteComponent.t()] | []
  def get_by_website_id(website_id) do
    WebsiteComponent
    |> where([wc], wc.website_id == ^website_id)
    |> Repo.all()
  end
end
