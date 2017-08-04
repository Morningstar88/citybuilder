defmodule Citybuilder.Repo.Migrations.AddLtreeToStoriesPosts do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS ltree"

    alter table(:stories_posts) do
      add :path, :ltree, null: false
    end

    create index(:stories_posts, [:path], unique: true)
  end

  def down do
    drop index(:stories_posts, [:path])

    alter table(:stories_posts) do
      remove :path
    end
  end
end
