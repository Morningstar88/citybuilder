defmodule Citybuilder.Web.ErrorHandler do
  use Citybuilder.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You need to login to write! Please signup or log in :)")
    |> redirect(to: user_path(conn, :signin))
  end
end
