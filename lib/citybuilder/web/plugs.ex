defmodule Citybuilder.Plugs do
  import Plug.Conn, only: [assign: 3, halt: 1]
  import Citybuilder.Web.Controller.Helpers, only: [can_modify?: 2]
  import Phoenix.Controller, only: [render: 3]
  alias Citybuilder.Stories

  def set_user(conn, _opts) do
    assign(conn, :user, Guardian.Plug.current_resource(conn))
  end

  def set_post(conn, _opts) do
    %{"post_id" => id} = conn.params
    assign(conn, :post, Stories.get_post!(id))
  end

  def check_can_modify(conn, %{key: key, message: message}) do
    if can_modify?(conn.assigns.user, Map.fetch!(conn.assigns, key)) do
      conn
    else
      conn
      |> render("access_error.js", message: message)
      |> halt
    end
  end
end
