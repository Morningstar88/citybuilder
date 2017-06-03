defmodule LiveStory.Repo.Migrations.CreateCommentUpvotes do
  use Ecto.Migration

  def change do
    create table(:stories_comments_upvotes) do
      add :comment_id, references(:stories_comments, on_delete: :nothing), null: false
      add :user_id, references(:auths_users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:stories_comments_upvotes, [:comment_id])
    create index(:stories_comments_upvotes, [:user_id])
    create unique_index(:stories_comments_upvotes, [:comment_id, :user_id])
  end
end
