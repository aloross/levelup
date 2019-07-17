defmodule Levelup.Repo.Migrations.CreatePositionsCompetencesLevels do
  use Ecto.Migration

  def change do
    create table(:positions_competences_levels) do
      add(:position_id, references(:positions, on_delete: :nothing))
      add(:competence_id, references(:competences, on_delete: :nothing))
      add(:level_id, references(:levels, on_delete: :nothing))

      timestamps()
    end

    create(index(:positions_competences_levels, [:position_id]))
    create(index(:positions_competences_levels, [:competence_id]))
    create(index(:positions_competences_levels, [:level_id]))
  end
end
