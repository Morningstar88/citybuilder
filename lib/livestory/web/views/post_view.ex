defmodule LiveStory.Web.PostView do
  use LiveStory.Web, :view

  @spec upvoted_class(button_state :: binary, upvote_state :: boolean) :: binary
  def upvoted_class("upvoted", true), do: ""
  def upvoted_class("upvoted", nil), do: "hidden "
  def upvoted_class("not_upvoted", true), do: "hidden "
  def upvoted_class("not_upvoted", nil), do: ""

  def root_path(path) do
    LiveStory.Stories.root_path(path)
  end

  # Avoid fail on less than 3 posts by doing different matches
  # Text duplication here is unavoidable.
  def welcome(true, conn, [post1, post2, post3 | _tail]) do
    "Today's top stories are #{link_post conn, post1}, #{link_post conn, post2} and #{link_post conn, post2}. Help us edit them."
  end
  def welcome(true, conn, [post1, post2]) do
    "Today's top stories are #{link_post conn, post1} and #{link_post conn, post2}. Help us edit them."
  end
  def welcome(true, conn, [post1]) do
    "Today's top story is #{link_post conn, post1}. Help us edit it."
  end
  def welcome(nil, conn, _posts) do
    ""
  end

  defp link_post(conn, post) do
    {:safe, link} = link post.title, to: post_path(conn, :show, post)
    link
  end
end
