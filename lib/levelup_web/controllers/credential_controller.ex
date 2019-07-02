defmodule LevelupWeb.CredentialController do
  use LevelupWeb, :controller

  alias Levelup.Accounts
  alias Levelup.Accounts.Credential

  def index(conn, _params) do
    credentials = Accounts.list_credentials()
    render(conn, "index.html", credentials: credentials)
  end

  def new(conn, _params) do
    changeset = Accounts.change_credential(%Credential{})

    tenants =
      Accounts.list_tenants()
      |> Enum.map(&{&1.title, &1.id})

    render(conn, "new.html", changeset: changeset, tenants: tenants)
  end

  def create(conn, %{"credential" => credential_params}) do
    case Accounts.create_credential(credential_params) do
      {:ok, credential} ->
        conn
        |> put_flash(:info, "Credential created successfully.")
        |> redirect(to: Routes.credential_path(conn, :show, credential))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    credential = Accounts.get_credential!(id)
    render(conn, "show.html", credential: credential)
  end

  def edit(conn, %{"id" => id}) do
    credential = Accounts.get_credential!(id)

    tenants =
      Accounts.list_tenants()
      |> Enum.map(&{&1.title, &1.id})

    changeset = Accounts.change_credential(credential)
    render(conn, "edit.html", credential: credential, changeset: changeset, tenants: tenants)
  end

  def update(conn, %{"id" => id, "credential" => credential_params}) do
    credential = Accounts.get_credential!(id)

    case Accounts.update_credential(credential, credential_params) do
      {:ok, credential} ->
        conn
        |> put_flash(:info, "Credential updated successfully.")
        |> redirect(to: Routes.credential_path(conn, :show, credential))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", credential: credential, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    credential = Accounts.get_credential!(id)
    {:ok, _credential} = Accounts.delete_credential(credential)

    conn
    |> put_flash(:info, "Credential deleted successfully.")
    |> redirect(to: Routes.credential_path(conn, :index))
  end
end
