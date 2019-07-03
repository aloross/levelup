defmodule Levelup.Repo.Migrations.AddRoleToCredential do
  use Ecto.Migration

  def change do
    alter table("credentials") do
      add :role, :string
    end
  end
end
