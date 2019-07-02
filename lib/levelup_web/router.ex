defmodule LevelupWeb.Router do
  use LevelupWeb, :router

  pipeline :auth do
    plug Levelup.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

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

  scope "/", LevelupWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    post "/logout", SessionController, :logout
    resources "/credentials", CredentialController
  end

  scope "/", LevelupWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/secret", PageController, :secret
  end
end
