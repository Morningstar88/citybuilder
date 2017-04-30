defmodule LiveStory.Web.SessionController do 
  use LiveStory.Web, :controller 
  # snip
  plug :scrub_params, "session" when action in ~w(create)
  

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case LiveStory.Session.authenticate(username, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        # |> put_flash(:info, "Welcome! Account created. Returning to main page.")
        |> redirect(to: "/")

      {:error, _err} ->
        conn
        |> put_flash(:info, "Sign Up failed. Try again.")
        |> redirect(to: "/users/signin")
    end
  end

  def unauthenticated(conn, params) do
    conn
    |> put_flash(:info, "Sign Up failed.")
    |> redirect(to: "/")
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out. cu later!")
    |> redirect(to: "/")
  end
end 