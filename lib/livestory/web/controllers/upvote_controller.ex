defmodule LiveStory.Web.PostController do
  use LiveStory.Web, :controller

  alias LiveStory.Stories
  alias LiveStory.Web.ErrorHandler

  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler] when not action in [:index, :show]
  plug :set_user
  plug :set_post when action in [:create]

  def create(conn, params) do
    post = conn.assigns.post
    case Stories.upvote(post.id, conn.assigns.user.id) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Upvoted Successfully")
        |> redirect(to: post_path(conn, :show, post))
      # show user flash for failed upvote
      # redirect back to the post to be upvoted page
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Upvote not successful") # maybe upvoted already? tell the user
        |> redirect(to: post_path(conn, :show, post))
    end
  end

  defp set_user(conn, _opts) do
    assign(conn, :user, Guardian.Plug.current_resource(conn))
  end

  defp set_post(conn, _opts) do
    %{"id" => id} = conn.params
    assign(conn, :post, Stories.get_post!(id))
  end
end