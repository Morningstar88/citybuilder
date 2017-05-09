defmodule LiveStory.Web.UpvoteView do
  use LiveStory.Web, :view

  def render("upvoted.json", %{post: post}) do
    %{
      post_id: post.id,
      action: :upvote
    }
  end

  def render("deleted.json", %{post: post}) do
    %{
      post_id: post.id,
      action: :delete_upvote
    }
  end

  def render("error.json", %{post: post}) do
    %{}
  end
end
