defmodule Levelup.Competences.Competence do
  use Ecto.Schema
  import Ecto.Changeset

  schema "competences" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(competence, attrs) do
    competence
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
