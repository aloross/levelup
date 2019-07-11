defmodule Levelup.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :firstname, :string
      add :lastname, :string
      add :identifier, :string
      add :position_id, references(:positions, on_delete: :nothing)

      timestamps()
    end

    create index(:persons, [:position_id])
  end
end
