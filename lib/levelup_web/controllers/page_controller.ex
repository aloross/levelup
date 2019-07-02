defmodule LevelupWeb.PageController do
  use LevelupWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def secret(conn, _) do
    credential = Guardian.Plug.current_resource(conn)
    render(conn, "secret.html", current_user: credential)
  end
end
