defmodule Levelup.Competences.PersonCompetenceLevel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Levelup.Persons.Person
  alias Levelup.Competences.{Competence, Level}

  schema "persons_competences_levels" do
    belongs_to :person, Person
    belongs_to :competence, Competence
    belongs_to :level, Level

    timestamps()
  end

  @doc false
  def changeset(person_competence_level, attrs) do
    person_competence_level
    |> cast(attrs, [:person_id, :competence_id, :level_id])
    |> validate_required([:person_id, :competence_id])
    |> foreign_key_constraint(:person_id)
    |> foreign_key_constraint(:competence_id)
    |> foreign_key_constraint(:level_id)
  end
end
