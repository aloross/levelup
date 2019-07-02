defmodule Levelup.Account do
  import Ecto.Query, warn: false
  alias Levelup.Repo

  alias Levelup.Account.Credential
  alias Comeonin.Bcrypt

  def authenticate_credential(username, plain_text_password) do
    query = from c in Credential, where: c.username == ^username

    case Repo.one(query) do
      nil ->
        Bcrypt.dummy_checkpw()
        {:error, :invalid_credentials}

      credential ->
        if Bcrypt.checkpw(plain_text_password, credential.password) do
          {:ok, credential}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def list_credentials do
    Repo.all(Credential)
  end

  def get_credential!(id), do: Repo.get!(Credential, id)

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end
end
