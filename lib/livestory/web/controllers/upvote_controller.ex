defmodule LiveStory.Web.UpvoteController do
  use LiveStory.Web, :controller

  import LiveStory.Plugs

  alias LiveStory.Stories
  alias LiveStory.Web.ErrorHandler

  # plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler] when not action in [:index, :show]
  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_post when action in [:create, :delete]

  def create(conn, _params) do
    post = conn.assigns.post
    case Stories.upvote(post.id, conn.assigns.user.id) do
      {:ok, _upvote} ->
        conn
        |> render("upvoted.json", post: post)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    post = conn.assigns.post
    {:ok, _post} = Stories.delete_upvote(post, conn.assigns.user.id)
    conn
    |> render("deleted.json", post: post)
  end
end
