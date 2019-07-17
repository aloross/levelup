defmodule Levelup.Competences.Level do
  use Ecto.Schema
  import Ecto.Changeset

  schema "levels" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(level, attrs) do
    level
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
