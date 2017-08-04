defmodule LiveStory.Web.PageController do
  use LiveStory.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
