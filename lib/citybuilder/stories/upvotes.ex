defmodule Citybuilder.Stories.Upvotes do
  use Ecto.Schema

  schema "stories_upvotes" do
    belongs_to :post, Citybuilder.Stories.Post
    belongs_to :user, Citybuilder.Auths.User

    timestamps()
  end
end
