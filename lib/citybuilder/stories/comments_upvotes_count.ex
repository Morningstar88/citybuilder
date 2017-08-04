defmodule Citybuilder.Stories.CommentUpvotesCount do
  use Ecto.Schema

  schema "stories_comments_upvotes_counts" do
    field :count, :integer, null: false, read_after_writes: true
    belongs_to :comment, Citybuilder.Stories.Comment

    timestamps()
  end
end
