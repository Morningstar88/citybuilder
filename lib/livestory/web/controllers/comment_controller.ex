defmodule LiveStory.Web.CommentController do
  use LiveStory.Web, :controller

  import LiveStory.Plugs

  alias LiveStory.Stories

  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_post

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
end
