defmodule LiveStory.Web.Router do
  use LiveStory.Web, :router

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

    resources "/posts", PostController do
      post "/upvotes", UpvoteController, :create
    end

    get "/posts/fork/:id", PostController , :fork

  end

  # Redirects https://www.amberbit.com/elixir-cocktails/phoenix/handling-url-redirects-in-phoenix-with-plug/

  # Other scopes may use custom stacks.
  # scope "/api", LiveStory.Web do
  #   pipe_through :api
  # end
end
