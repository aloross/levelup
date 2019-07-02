defmodule LevelupWeb.PageController do
  use LevelupWeb, :controller
  alias Levelup.Account.Item

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def secret(conn, _) do
    credential = Guardian.Plug.current_resource(conn)
    items = Item.all(credential.tenant.slug)
    render(conn, "secret.html", current_user: credential, items: items)
  end
end
