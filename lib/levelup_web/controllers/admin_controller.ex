defmodule LevelupWeb.AdminController do
  use LevelupWeb, :controller
  alias Levelup.Accounts.Item

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
