defmodule LiveStory.Web.UpvoteView do
  use LiveStory.Web, :view

  def render("upvoted.json", %{post: post}) do
    %{
      upvote_post: post.id
    }
  end

  def render("error.json", %{post: post}) do
    %{}
  end
end
