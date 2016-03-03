defmodule PhoenixApp.Router do
  use PhoenixApp.Web, :router

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

  scope "/", PhoenixApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PhoenixApp do
    pipe_through :api

    resources "/watchlists", WatchlistController, except: [:new, :edit, :show]
    get "/watchlists/:chat_id", WatchlistController, :list
  end
end
