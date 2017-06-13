defmodule LiveStory.Web.ForkController do
  use LiveStory.Web, :controller

  import LiveStory.Plugs

  alias LiveStory.Stories

  plug :set_post

  def index(conn, _params) do
    forks = Stories.list_forks(conn.assigns.post.original_post_id)
    render conn, "index.html", forks: forks
  end
end
