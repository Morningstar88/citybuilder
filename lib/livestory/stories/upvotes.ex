defmodule LiveStory.Stories.Upvotes do
  use Ecto.Schema

  schema "stories_forked_posts" do
    belongs_to :post, LiveStory.Stories.Post
    belongs_to :user, LiveStory.Auths.User

    timestamps()
  end
end
