defmodule Citybuilder.Repo.Migrations.SwitchToOriginalPostId do
  use Ecto.Migration

  def up do
    alter table(:stories_posts) do
      add :original_post_id, references(:stories_posts)
    end

    drop table(:stories_forked_posts)

    create index(:stories_posts, :original_post_id)
  end

  def down do
    alter table(:stories_posts) do
      remove :original_post_id
    end

    create table(:stories_forked_posts) do
      add :original_post_id, references(:stories_posts, on_delete: :nothing)
      add :forked_post_id, references(:stories_posts, on_delete: :nothing)

      timestamps()
    end

    create index(:stories_forked_posts, [:original_post_id])
    create index(:stories_forked_posts, [:forked_post_id])
    create index(:stories_forked_posts, [:original_post_id, :forked_post_id], unique: true)
  end
end
