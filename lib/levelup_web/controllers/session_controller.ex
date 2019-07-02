defmodule LevelupWeb.SessionController do
  use LevelupWeb, :controller

  alias Levelup.{Accounts, Accounts.Credential, Accounts.Guardian}

  def new(conn, _) do
    changeset = Accounts.change_credential(%Credential{})
    maybe_credential = Guardian.Plug.current_resource(conn)

    if maybe_credential do
      redirect(conn, to: "/secret")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"credential" => %{"username" => username, "password" => password}}) do
    Accounts.authenticate_credential(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, credential}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(credential)
    |> redirect(to: "/secret")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
