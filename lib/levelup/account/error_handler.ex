defmodule Levelup.Account.ErrorHandler do
  import Plug.Conn
  use LevelupWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, _, _) do
    conn
    |> put_flash(:error, "You need to be authenticated to access this page.")
    |> redirect(to: Routes.session_path(conn, :login))
  end
end
