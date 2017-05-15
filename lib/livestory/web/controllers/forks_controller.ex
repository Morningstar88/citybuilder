defmodule LiveStory.Web.ForkController do
  use LiveStory.Web, :controller

  alias LiveStory.Stories

  def index(conn, %{"post_id" => post_id}) do
    forks = Stories.list_forks(post_id)
    render conn, "index.html", forks: forks
  end
end
