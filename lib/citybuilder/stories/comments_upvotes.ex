defmodule LiveStory.Stories.CommentUpvotes do
  use Ecto.Schema

  schema "stories_comments_upvotes" do
    belongs_to :comment, LiveStory.Stories.Comment
    belongs_to :user, LiveStory.Auths.User

    timestamps()
  end
end
