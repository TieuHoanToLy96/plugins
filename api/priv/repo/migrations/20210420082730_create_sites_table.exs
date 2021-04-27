defmodule Api.Repo.Migrations.CreateSitesTable do
  use Ecto.Migration

  def up do
    create table(:sites) do
      add :name, :string
      add :url, :string
      add :is_deleted, :boolean, default: false
      add :owner_id, :binary_id, null: false
      add :creator_id, :binary_id, null: false

      timestamps()
    end
  end

  def down do
    drop table(:sites)
  end
end
