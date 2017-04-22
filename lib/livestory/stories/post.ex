defmodule LiveStory.Stories.Post do
  use Ecto.Schema

  schema "stories_posts" do
    field :body, :string
    field :title, :string
    belongs_to :user, LiveStory.Auths.User

    timestamps()
  end
end
