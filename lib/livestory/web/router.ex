defmodule LiveStory.Web.Router do
  use LiveStory.Web, :router

  require Logger

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveStory.Web do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/users/signin", UserController, :signin
    resources "/users", UserController

    post "/signin", SessionController, :create
    delete "/signout", SessionController, :logout

    get "/", PostController, :index

    resources "/posts", PostController, param: "post_id" do
      post "/upvotes", UpvoteController, :create
      delete "/upvotes", UpvoteController, :delete
      resources "/forks", ForkController, only: [:index]
      resources "/comments", CommentController, only: [:create]
    end
    resources "/comments", CommentController, only: [:delete, :update] do
      resources "/upvotes", CommentUpvoteController, only: [:create, :delete],
        as: :upvote, singleton: true
    end
    post "/posts/:post_id", PostController, :restore
    post "/comments/:id", CommentController, :restore
    # workaround, use PUT instead of GET, because with GET, phoenix_ujs
    # won't send Origin header and this will trigger CORS forgery protection
    # https://github.com/jalkoby/phoenix_ujs/issues/4
    put "/comments/:id/edit", CommentController, :edit

    resources "/topics", TopicController, only: [:show], param: "slug"

    get "/posts/fork/:post_id", PostController , :fork
  end

  # Redirects https://www.amberbit.com/elixir-cocktails/phoenix/handling-url-redirects-in-phoenix-with-plug/

  # Other scopes may use custom stacks.
  # scope "/api", LiveStory.Web do
  #   pipe_through :api
  # end
end
