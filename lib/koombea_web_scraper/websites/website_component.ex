defmodule KoombeaWebScraper.Websites.WebsiteComponent do
  @moduledoc """
  Website component schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias KoombeaWebScraper.Websites.Website

  @type t :: %__MODULE__{
          id: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t(),
          url: String.t(),
          name: String.t(),
          website_id: integer()
        }

  @required_fields ~w(url name user_id)a

  schema "website_components" do
    timestamps()

    field :url, :string
    field :name, :string

    belongs_to :website, Website
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_url(attrs.url)
  end

  defp validate_url(changeset, url) do
    if String.match?(url, ~r/^((http|https|www):\/\/)?[a-zA-Z0-9._-]+(\.[a-zA-Z0-9._-]+)+.*$/i) do
      changeset
    else
      add_error(changeset, :url, "URL is invalid")
    end
  end
end
