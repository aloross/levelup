defmodule LevelupWeb.PageController do
  use LevelupWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
