defmodule LiveStory.Web.PostView do
  use LiveStory.Web, :view

  def upvoted_class(true), do: "upvoted "
  def upvoted_class(_), do: ""
end
