defmodule LiveStory.Stories.Comment do
  use Ecto.Schema

  schema "stories_comments" do
    field :body, :string
    field :guest_name, :string
    belongs_to :user, Livestory.Auth.User
    belongs_to :post, LiveStory.Stories.Post

    timestamps()
  end
end
