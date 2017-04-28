defmodule LiveStory.Repo.Migrations.CreateStoriesUpvotes do
  use Ecto.Migration

  def change do
    create table(:stories_upvotes) do
      add :post_id, references(:stories_posts, on_delete: :nothing)
      add :user_id, references(:auths_users, on_delete: :nothing)

      timestamps()
    end

    create index(:stories_upvotes, [:post_id])
    create index(:stories_upvotes, [:user_id])
    create unique_index(:stories_upvotes, [:post_id, :user_id])
  end
end
