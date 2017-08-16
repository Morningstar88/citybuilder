defmodule Citybuilder.Stories.Post do
  use Ecto.Schema

  schema "stories_posts" do
    field :body, :string
    field :title, :string
    field :plan, :string
    field :done_so_far_one, :string
    field :done_so_far_two, :string
    field :done_so_far_three, :string
    field :done_so_far_one_title, :string
    field :done_so_far_two_title, :string
    field :done_so_far_three_title, :string
    field :name_of_gallery, :string
    field :future_plans_title, :string

    field :project_pic, Citybuilder.ProjectPic.Type
    field :text_pic_one, Citybuilder.ProjectPic.Type
    field :text_pic_two, Citybuilder.ProjectPic.Type
    field :text_pic_three, Citybuilder.ProjectPic.Type
    field :small_pic_1_caption, :string
    field :small_pic_2_caption, :string
    field :small_pic_3_caption, :string
    field :project_location, :string
    field :published, :boolean, default: true
    field :path, :string, null: false, read_after_writes: true
    field :removed_by_owner, :boolean, default: false
    field :removed_by_moderator, :boolean, default: false
    belongs_to :user, Citybuilder.Auths.User
    belongs_to :modified_by, Citybuilder.Auths.User
    belongs_to :original_post, Citybuilder.Stories.Post
    belongs_to :topic, Citybuilder.Stories.Topic
    has_one :upvotes_count, Citybuilder.Stories.UpvotesCounts
    has_many :comments, Citybuilder.Stories.Comment

    timestamps()
  end
end
