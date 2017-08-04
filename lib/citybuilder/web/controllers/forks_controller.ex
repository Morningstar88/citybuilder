defmodule Citybuilder.Web.ForkController do
  use Citybuilder.Web, :controller

  import Citybuilder.Plugs

  alias Citybuilder.Stories

  plug :set_post

  def index(conn, _params) do
    forks = Stories.list_forks(conn.assigns.post.original_post_id)
    render conn, "index.html", forks: forks
  end
end
