defmodule Citybuilder.Stories.CommentUpvotes do
  use Ecto.Schema

  schema "stories_comments_upvotes" do
    belongs_to :comment, Citybuilder.Stories.Comment
    belongs_to :user, Citybuilder.Auths.User

    timestamps()
  end
end
