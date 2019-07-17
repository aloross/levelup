defmodule Levelup.Repo.Migrations.CreatePersonsCompetencesLevels do
  use Ecto.Migration

  def change do
    create table(:persons_competences_levels) do
      add(:person_id, references(:persons, on_delete: :nothing))
      add(:competence_id, references(:competences, on_delete: :nothing))
      add(:level_id, references(:levels, on_delete: :nothing))

      timestamps()
    end

    create(index(:persons_competences_levels, [:person_id]))
    create(index(:persons_competences_levels, [:competence_id]))
    create(index(:persons_competences_levels, [:level_id]))
  end
end
