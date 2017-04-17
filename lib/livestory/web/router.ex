defmodule LiveStory.Web.Router do
  use LiveStory.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveStory.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PostController, :index
    resources "/posts", PostController
  end
  
  # Redirects https://www.amberbit.com/elixir-cocktails/phoenix/handling-url-redirects-in-phoenix-with-plug/

  # Other scopes may use custom stacks.
  # scope "/api", LiveStory.Web do
  #   pipe_through :api
  # end
end
