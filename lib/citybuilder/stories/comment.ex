defmodule Citybuilder.Stories.Comment do
  use Ecto.Schema

  schema "stories_comments" do
    field :body, :string
    field :user_name, :string
    field :removed_by_owner, :boolean, default: false
    field :removed_by_moderator, :boolean, default: false
    belongs_to :user, Citybuilder.Auths.User
    belongs_to :modified_by, Citybuilder.Auths.User
    belongs_to :post, Citybuilder.Stories.Post
    has_one :upvotes_count, Citybuilder.Stories.CommentUpvotesCount

    timestamps()
  end
end
