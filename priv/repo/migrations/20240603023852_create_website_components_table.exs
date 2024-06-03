defmodule KoombeaWebScraper.Repo.Migrations.CreateWebsiteComponentsTable do
  use Ecto.Migration

  def change do
    create table("website_components") do
      timestamps()

      add :url, :string
      add :name, :string
      add :website_id, references(:websites)
    end
  end
end
