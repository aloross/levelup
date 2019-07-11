defmodule Levelup.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions) do
      add :name, :string

      timestamps()
    end

  end
end
