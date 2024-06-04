defmodule KoombeaWebScraper.Repo.Migrations.CreateWebsiteComponentsTable do
  use Ecto.Migration

  def change do
    create table("website_components") do
      timestamps()

      add :url, :string, size: 511
      add :name, :string
      add :website_id, references(:websites)
    end

    create index(:website_components, [:website_id])
  end
end
