defmodule Levelup.Persons.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Levelup.Positions.Position
  alias Levelup.Competences.PersonCompetenceLevel

  schema "persons" do
    field :firstname, :string
    field :identifier, :string
    field :lastname, :string
    belongs_to :position, Position
    has_many :competences, PersonCompetenceLevel

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:firstname, :lastname, :identifier])
    |> validate_required([:firstname, :lastname, :identifier])
  end
end
