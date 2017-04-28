defmodule LiveStory.Stories.Post do
  use Ecto.Schema

  schema "stories_posts" do
    field :body, :string
    field :title, :string
    field :published, :boolean, default: true
    belongs_to :user, LiveStory.Auths.User
    has_one :original_link, LiveStory.Stories.ForkedPost, foreign_key: :forked_post_id
    has_one :original_post, through: [:original_link, :original_post]

    timestamps()
  end
end
