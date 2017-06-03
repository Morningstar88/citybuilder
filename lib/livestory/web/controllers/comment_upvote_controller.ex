defmodule LiveStory.Web.CommentUpvoteController do
  use LiveStory.Web, :controller

  import LiveStory.Plugs

  alias LiveStory.Stories

  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_comment

  def create(conn, _params) do
    comment = conn.assigns.comment
    case Stories.comment_upvote(comment.id, conn.assigns.user.id) do
      {:ok, _upvote} ->
        comment = Stories.preload_comment_upvotes_count(comment)
        conn
        |> render("upvoted.js", comment: comment, upvote: true)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("error.js", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    {:ok, _comment} = Stories.delete_comment_upvote(conn.assigns.comment, conn.assigns.user.id)
    comment = Stories.preload_comment_upvotes_count(conn.assigns.comment)
    conn
    |> render("delete.js", comment: comment, upvote: nil)
  end

  defp set_comment(%{params: %{"comment_id" => id}} = conn, _opts) do
    assign(conn, :comment, Stories.get_comment!(id))
  end
end
