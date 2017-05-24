defmodule LiveStory.Plugs do
  import Plug.Conn, only: [assign: 3]

  alias LiveStory.Stories

  def set_user(conn, _opts) do
    assign(conn, :user, Guardian.Plug.current_resource(conn))
  end

  def set_post(conn, _opts) do
    %{"post_id" => id} = conn.params
    assign(conn, :post, Stories.get_post!(id))
  end
end
