defmodule LiveStory.Stories.Post do
  use Ecto.Schema

  schema "stories_posts" do
    field :body, :string
    field :title, :string
    field :plan, :string
    field :done_so_far, :string
    field :project_pic, Livestory.ProjectPic.Type
    field :published, :boolean, default: true
    field :path, :string, null: false, read_after_writes: true
    field :removed_by_owner, :boolean, default: false
    field :removed_by_moderator, :boolean, default: false
    belongs_to :user, LiveStory.Auths.User
    belongs_to :modified_by, LiveStory.Auths.User
    belongs_to :original_post, LiveStory.Stories.Post
    belongs_to :topic, LiveStory.Stories.Topic
    has_one :upvotes_count, LiveStory.Stories.UpvotesCounts
    has_many :comments, LiveStory.Stories.Comment

    timestamps()
  end
end
