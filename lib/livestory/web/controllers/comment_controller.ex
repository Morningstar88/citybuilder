defmodule LiveStory.Web.CommentController do
  use LiveStory.Web, :controller

  import LiveStory.Plugs

  alias LiveStory.Stories

  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_post when not action in [:edit, :update, :delete]
  plug :set_comment when action in [:edit, :update, :delete]
  plug :check_can_modify_comment when action in [:edit, :update, :delete]

  def create(conn, params) do
    post = conn.assigns.post
    case Stories.create_comment(params["comment"], post.id, conn.assigns.user.id) do
      {:ok, comment} ->
        conn
        |> render("create.js",
          comment: comment,
          changeset: Stories.new_post_comment(post, %{
            user_name: conn.assigns.user.username
          })
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
    case Stories.update_comment(params["comment"], conn.assigns.comment, conn.assigns.user) do
      {:ok, comment} ->
        conn
        |> render("update.js",
          comment: comment,
          post: conn.assigns.comment.post,
          changeset: Stories.new_post_comment(conn.assigns.comment.post, %{
            user_name: conn.assigns.user.username
          })
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("error.js", changeset: changeset, post: conn.assigns.post)
    end
  end

  def delete(conn, _params) do
    {:ok, comment} = Stories.delete_comment(conn.assigns.comment, conn.assigns.user)
    conn
    |> render("delete.js", comment: comment)
  end

  defp set_comment(%{params: %{"id" => id}} = conn, _opts) do
    assign(conn, :comment, Stories.get_comment!(id))
  end

  # similar to function in PostController, but has some differences
  defp check_can_modify_comment(conn, _opts) do
    if can_modify_comment?(conn.assigns.user, conn.assigns.comment) do
      conn
    else
      conn
      |> render("access_error.js", message: "This comment belongs to another user! You can't edit it.")
      |> halt
    end
  end
end
