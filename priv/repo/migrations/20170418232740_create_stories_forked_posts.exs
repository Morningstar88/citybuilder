defmodule Citybuilder.Repo.Migrations.CreateCitybuilder.StoriesForkedPosts do
  use Ecto.Migration

  def change do
    create table(:stories_forked_posts) do
      add :original_post_id, references(:stories_posts, on_delete: :nothing)
      add :forked_post_id, references(:stories_posts, on_delete: :nothing)

      timestamps()
    end

    create index(:stories_forked_posts, [:original_post_id])
    create index(:stories_forked_posts, [:forked_post_id])
  end
end
