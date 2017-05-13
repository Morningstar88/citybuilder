defmodule LiveStory.Web.TopicController do
  use LiveStory.Web, :controller
  alias LiveStory.Stories

  def show(conn, %{"slug" => slug}) do
    topic = Stories.get_topic!(slug)
    posts = Stories.list_posts(topic.id)
    render conn, "show.html", topic: topic, posts: posts
  end
end
