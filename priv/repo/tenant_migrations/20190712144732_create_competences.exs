defmodule Levelup.Repo.Migrations.CreateCompetences do
  use Ecto.Migration

  def change do
    create table(:competences) do
      add :name, :string

      timestamps()
    end

  end
end
