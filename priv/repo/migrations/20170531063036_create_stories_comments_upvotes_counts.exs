defmodule LiveStory.Repo.Migrations.CreateStoriesCommentsUpvotesCounts do
  use Ecto.Migration

  def change do
    create table(:stories_comments_upvotes_counts) do
      add :count, :integer, null: false, default: 0
      add :comment_id, references(:stories_comments, on_delete: :nothing), null: false

      timestamps()
    end

    create constraint(:stories_comments_upvotes_counts, :stories_upvotes_counts_must_be_not_negative, check: "count >= 0")

    create index(:stories_comments_upvotes_counts, [:comment_id], unique: true)
    create index(:stories_comments_upvotes_counts, :count)
  end
end
