defmodule LiveStory.Web.CommentController do
  use LiveStory.Web, :controller

  import LiveStory.Plugs

  alias LiveStory.Stories

  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_post when not action in [:edit, :update, :delete]
  plug :set_comment when action in [:edit, :update, :delete]
  plug :check_same_user when action in [:edit, :update, :delete]

  def create(conn, params) do
    post = conn.assigns.post
    case Stories.create_comment(params["comment"], post.id, conn.assigns.user.id) do
      {:ok, comment} ->
        conn
        |> render("create.js",
          comment: comment,
          changeset: Stories.new_post_comment(post)
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("error.js", changeset: changeset, post: post)
    end
  end

  def edit(conn, _params) do
    changeset = conn.assigns.comment
    |> Stories.comment_changeset
    conn
    |> render("edit.js", changeset: changeset)
  end

  def update(conn, params) do
    case Stories.update_comment(params["comment"], conn.assigns.comment) do
      {:ok, comment} ->
        conn
        |> render("update.js",
          comment: comment,
          post: conn.assigns.comment.post,
          changeset: Stories.new_post_comment(conn.assigns.comment.post)
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("error.js", changeset: changeset, post: conn.assigns.post)
    end
  end

  defp set_comment(%{params: %{"id" => id}} = conn, _opts) do
    assign(conn, :comment, Stories.get_comment!(id))
  end

  # similar to function in PostController, but has some differences
  defp check_same_user(conn, _opts) do
    if conn.assigns.user.id != conn.assigns.comment.user_id do
      conn
      |> render("access_error.js", message: "This comment belongs to another user! You can't edit it.")
    else
      conn
    end
  end
end
