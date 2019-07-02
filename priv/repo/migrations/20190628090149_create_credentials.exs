defmodule Levelup.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :username, :string
      add :password, :string

      timestamps()
    end
  end
end
