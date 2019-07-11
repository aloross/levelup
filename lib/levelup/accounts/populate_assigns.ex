defmodule Levelup.Accounts.PopulateAssigns do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    credential = Guardian.Plug.current_resource(conn)
    logged_in = credential != nil

    if logged_in do
      conn
      |> assign(:logged_in, logged_in)
      |> assign(:current_user, credential)
      |> assign(:current_tenant, credential.tenant.slug)
      |> assign(:is_admin, credential.role == "admin")
      |> assign(:is_manager, credential.role == "manager" || credential.role == "admin")
    else
      conn
      |> assign(:logged_in, logged_in)
    end
  end
end
