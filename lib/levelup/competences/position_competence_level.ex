defmodule Levelup.Competences.PositionCompetenceLevel do
  use Ecto.Schema
  import Ecto.Changeset

  alias Levelup.Positions.Position
  alias Levelup.Competences.{Competence, Level}

  schema "positions_competences_levels" do
    belongs_to :position, Position
    belongs_to :competence, Competence
    belongs_to :level, Level

    timestamps()
  end

  @doc false
  def changeset(position_competence_level, attrs) do
    position_competence_level
    |> cast(attrs, [:position_id, :competence_id, :level_id])
    |> validate_required([:position_id, :competence_id])
    |> foreign_key_constraint(:position_id)
    |> foreign_key_constraint(:competence_id)
    |> foreign_key_constraint(:level_id)
  end
end
