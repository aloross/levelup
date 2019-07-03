defmodule Levelup.Accounts.EnsureManager do
  import Plug.Conn
  use LevelupWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.is_manager do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorised to access this resource")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
