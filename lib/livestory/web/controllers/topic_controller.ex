defmodule LiveStory.Web.TopicController do
  use LiveStory.Web, :controller
  alias LiveStory.Stories

  def show(conn, %{"slug" => slug}) do
    topic = Stories.get_topic!(slug)
    render conn, "show.html", topic: topic
  end
end
