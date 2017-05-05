defmodule LiveStory.Web.UpvoteController do
  use LiveStory.Web, :controller

  alias LiveStory.Stories
  alias LiveStory.Web.ErrorHandler

  # plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler] when not action in [:index, :show]
  plug Guardian.Plug.EnsureAuthenticated, [handler: ErrorHandler]
  plug :set_user
  plug :set_post when action in [:create]

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

  defp set_user(conn, _opts) do
    assign(conn, :user, Guardian.Plug.current_resource(conn))
  end

  defp set_post(conn, _opts) do
    %{"post_id" => id} = conn.params
    assign(conn, :post, Stories.get_post!(id))
  end
end
