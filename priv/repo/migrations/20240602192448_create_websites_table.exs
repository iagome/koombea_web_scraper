defmodule KoombeaWebScraper.Repo.Migrations.CreateWebsitesTable do
  use Ecto.Migration

  def change do
    create table("websites") do
      timestamps()

      add :url, :string, null: false
      add :name, :string
      add :total_links, :integer
      add :user_id, references(:users)
    end

    create index(:websites, [:user_id])
  end
end
