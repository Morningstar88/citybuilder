defmodule LiveStory.Web.PostView do
  use LiveStory.Web, :view

  @spec upvoted_class(button_state :: binary, upvote_state :: boolean) :: binary
  def upvoted_class("upvoted", true), do: ""
  def upvoted_class("upvoted", nil), do: "hidden "
  def upvoted_class("not_upvoted", true), do: "hidden "
  def upvoted_class("not_upvoted", nil), do: ""
end
