defmodule LiveStory.Web.ErrorHandler do
  use LiveStory.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You are not authenticated. Please log in.")
    |> redirect(to: user_path(conn, :signin))
  end
end
