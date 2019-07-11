defmodule LevelupWeb.Router do
  use LevelupWeb, :router

  pipeline :auth do
    plug Levelup.Accounts.Pipeline
    plug Levelup.Accounts.PopulateAssigns
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :ensure_manager do
    plug Levelup.Accounts.EnsureManager
  end

  pipeline :ensure_admin do
    plug Levelup.Accounts.EnsureAdmin
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
  end

  scope "/", LevelupWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/positions", PositionController
    resources "/persons", PersonController
  end

  scope "/", LevelupWeb do
    pipe_through [:browser, :auth, :ensure_auth, :ensure_manager]
    resources "/credentials", CredentialController
  end

  scope "/admin", LevelupWeb do
    pipe_through [:browser, :auth, :ensure_auth, :ensure_admin]

    get "/", AdminController, :index
  end
end
