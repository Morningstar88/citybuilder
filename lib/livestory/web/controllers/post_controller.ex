defmodule LiveStory.Web.PostController do
  use LiveStory.Web, :controller

  alias LiveStory.Stories

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    posts = Stories.list_posts() #Original code
    render(conn, "index.html", posts: posts, user: user)
  end
  
  #Udia Web Controllers
  #https://github.com/udia-software/udia/tree/master/lib/udia/web/controllers
  
  #Order posts by newest first:
  #http://stackoverflow.com/questions/42843358/phoenix-application-posts-show-newest-first
  
#   def index(conn, _params) do
#     posts = Repo.all(from Post, order_by: [desc: :inserted_at])
#     render(conn, "index.html", posts: posts)
#   end

  def new(conn, _params) do
    changeset = Stories.change_post(%LiveStory.Stories.Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)
    case Stories.create_post(post_params, user) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created! ヽ(´▽`)/")
        |> redirect(to: post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
 
 def fork(conn, %{"id" => id}) do
    post = Stories.get_post!(id)
    IO.inspect post
    forked_post = Stories.create_forked_post(post)
    changeset = Stories.change_post(forked_post)
    changeset = Stories.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
end
 
 
 
  # Old Forked post code 
  # def fork(conn, %{"id" => id}) do
  #     post = Stories.get_post!(id)
  #     forked_post = post 
  #       {:ok, forked_post} ->
  #         conn
  #         |> put_flash(:info, :"You just forked that post.")
  #         |> redirect(to: post_path(conn, :show, post))
  #       {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # # end
      
      
  def show(conn, %{"id" => id}) do
    post = Stories.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Stories.get_post!(id)
    changeset = Stories.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Stories.get_post!(id)

    case Stories.update_post(post, post_params) do
      {:ok, post} ->
        conn
     #  |> put_flash(:info, "Post created/updated. Ψ ")
        |> redirect(to: post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Stories.get_post!(id)
    {:ok, _post} = Stories.delete_post(post)
    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
