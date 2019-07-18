defmodule Levelup.Positions.Position do
  use Ecto.Schema
  import Ecto.Changeset
  alias Levelup.Competences.PositionCompetenceLevel

  schema "positions" do
    field :name, :string
    has_many :competences, PositionCompetenceLevel

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
