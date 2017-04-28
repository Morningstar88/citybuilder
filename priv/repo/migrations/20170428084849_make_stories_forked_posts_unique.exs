defmodule LiveStory.Repo.Migrations.MakeStoriesForkedPostsUnique do
  use Ecto.Migration

  def change do
    create index(:stories_forked_posts, [:original_post_id, :forked_post_id], unique: true)
  end
end
