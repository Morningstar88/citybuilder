defmodule LiveStory.Web.CommentController do
  use LiveStory.Web, :controller

  require Logger

  import LiveStory.Plugs

  alias LiveStory.Stories

  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_post when not action in [:edit, :update, :delete]
  plug :set_comment when action in [:edit, :update, :delete]
  plug :check_can_modify_comment when action in [:edit, :update, :delete]
  plug :check_captcha when action in [:create]

  def create(conn, params) do
    post = conn.assigns.post
    case Stories.create_comment(params["comment"], post.id, conn.assigns.user.id) do
      {:ok, comment} ->
        conn
        |> put_flash(:captcha, true)
        |> render("create.js",
          comment: comment,
          changeset: Stories.new_post_comment(post, %{
            user_name: conn.assigns.user.username
          })
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:captcha, true)
        |> render("create_error.js", changeset: changeset, post: post)
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
        upvote = Stories.list_user_comment_upvotes(conn.assigns.user, [comment.id])[comment.id]
        comment = Stories.preload_comment_upvotes_count(comment)
        conn
        |> put_flash(:captcha, true)
        |> render("update.js",
          comment: comment,
          upvote: upvote,
          post: conn.assigns.comment.post,
          changeset: Stories.new_post_comment(conn.assigns.comment.post, %{
            user_name: conn.assigns.user.username
          })
        )
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("update_error.js", changeset: changeset, post: conn.assigns.comment.post)
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

  defp check_captcha(conn, _opts) do
    case Recaptcha.verify(conn.params["g-recaptcha-response"]) do
      {:ok, _response} ->
        Logger.info("captcha checked")
        conn
      {:error, _errors} ->
        Logger.info("captcha error")
        conn
        |> put_flash(:captcha, true)
        |> render("captcha_error.js")
        |> halt
    end
  end
end
