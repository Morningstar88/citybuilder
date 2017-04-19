defmodule LiveStory.Stories.ForkedPost do
  use Ecto.Schema

  schema "stories_forked_posts" do
    belongs_to :original_post, LiveStory.Stories.Post, foreign_key: :original_post_id
    belongs_to :forked_post, LiveStory.Stories.Post, foreign_key: :forked_post_id

    timestamps()
  end
end
