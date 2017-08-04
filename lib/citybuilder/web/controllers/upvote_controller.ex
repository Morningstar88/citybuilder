defmodule Citybuilder.Web.UpvoteController do
  use Citybuilder.Web, :controller

  import Citybuilder.Plugs

  alias Citybuilder.Stories

  # plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler] when not action in [:index, :show]
  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_post when action in [:create, :delete]

  def create(conn, _params) do
    post = conn.assigns.post
    case Stories.upvote(post.id, conn.assigns.user.id) do
      {:ok, _upvote} ->
        conn
        |> render("upvoted.js", post: reload(post), forks_count: forks_count(post))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("error.js", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    post = conn.assigns.post
    {:ok, _post} = Stories.delete_upvote(post, conn.assigns.user.id)
    conn
    |> render("deleted.js", post: reload(post), forks_count: forks_count(post))
  end

  defp forks_count(post) do
    Stories.count_forks([post.path])
  end

  defp reload(post) do
    Stories.get_post!(post.id)
  end
end
