defmodule KoombeaWebScraper.Websites.Website do
  @moduledoc """
  Website schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias KoombeaWebScraper.Accounts.User

  @type t :: %__MODULE__{
          id: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t(),
          url: String.t(),
          name: String.t(),
          total_links: integer(),
          user_id: integer()
        }

  @required_fields ~w(user_id)a
  @optional_fields ~w(url name total_links)a

  schema "websites" do
    timestamps()

    field :url, :string
    field :name, :string
    field :total_links, :integer

    belongs_to :user, User
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_url(attrs.url)
  end

  def validate_url_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:url])
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
