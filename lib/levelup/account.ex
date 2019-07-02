defmodule Levelup.Account do
  import Ecto.Query, warn: false
  alias Levelup.Repo

  alias Levelup.Account.User
  alias Comeonin.Bcrypt

  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.username == ^username

    case Repo.one(query) do
      nil ->
        Bcrypt.dummy_checkpw()
        {:error, :invalid_credentials}

      user ->
        if Bcrypt.checkpw(plain_text_password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
