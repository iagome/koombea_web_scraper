defmodule KoombeaWebScraper.Websites.WebsiteComponent do
  @moduledoc """
  Website component schema
  """

  use Ecto.Schema

  alias KoombeaWebScraper.Websites.Website

  @type t :: %__MODULE__{
          id: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t(),
          url: String.t(),
          name: String.t(),
          website_id: integer()
        }

  schema "website_components" do
    timestamps()

    field :url, :string
    field :name, :string

    belongs_to :website, Website
  end
end
