defmodule Levelup.Competences do
  import Ecto.Query, warn: false
  alias Levelup.Repo

  alias Levelup.Competences.Competence

  def list_competence_and_level_options(tenant) do
    competences = list_competences(tenant) |> Enum.map(&{&1.name, &1.id})
    levels = list_levels(tenant) |> Enum.map(&{&1.name, &1.id})

    %{competences: competences, levels: levels}
  end

  def list_competences(tenant) do
    Repo.all(Competence, prefix: Triplex.to_prefix(tenant))
  end

  def get_competence!(id, tenant),
    do: Repo.get!(Competence, id, prefix: Triplex.to_prefix(tenant))

  def create_competence(attrs \\ %{}, tenant) do
    %Competence{}
    |> Competence.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  def update_competence(%Competence{} = competence, attrs, tenant) do
    competence
    |> Competence.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(tenant))
  end

  def delete_competence(%Competence{} = competence, tenant) do
    Repo.delete(competence, prefix: Triplex.to_prefix(tenant))
  end

  def change_competence(%Competence{} = competence) do
    Competence.changeset(competence, %{})
  end

  alias Levelup.Competences.Level

  def list_levels(tenant) do
    Repo.all(Level, prefix: Triplex.to_prefix(tenant))
  end

  def get_level!(id, tenant), do: Repo.get!(Level, id, prefix: Triplex.to_prefix(tenant))

  def create_level(attrs \\ %{}, tenant) do
    %Level{}
    |> Level.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  def update_level(%Level{} = level, attrs, tenant) do
    level
    |> Level.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(tenant))
  end

  def delete_level(%Level{} = level, tenant) do
    Repo.delete(level, prefix: Triplex.to_prefix(tenant))
  end

  def change_level(%Level{} = level) do
    Level.changeset(level, %{})
  end

  alias Levelup.Competences.PositionCompetenceLevel

  def list_positions_competences_levels(tenant) do
    Repo.all(PositionCompetenceLevel, prefix: Triplex.to_prefix(tenant))
    |> Repo.preload([:position, :competence, :level])
  end

  def get_position_competence_level!(id, tenant) do
    Repo.get!(PositionCompetenceLevel, id, prefix: Triplex.to_prefix(tenant))
    |> Repo.preload([:position, :competence, :level])
  end

  def create_position_competence_level(attrs \\ %{}, tenant) do
    %PositionCompetenceLevel{}
    |> PositionCompetenceLevel.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  def update_position_competence_level(
        %PositionCompetenceLevel{} = position_competence_level,
        attrs,
        tenant
      ) do
    position_competence_level
    |> PositionCompetenceLevel.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(tenant))
  end

  def delete_position_competence_level(
        %PositionCompetenceLevel{} = position_competence_level,
        tenant
      ) do
    Repo.delete(position_competence_level, prefix: Triplex.to_prefix(tenant))
  end

  def change_position_competence_level(%PositionCompetenceLevel{} = position_competence_level) do
    PositionCompetenceLevel.changeset(position_competence_level, %{})
  end

  alias Levelup.Competences.PersonCompetenceLevel

  def list_persons_competences_levels(person, tenant) do
    PersonCompetenceLevel
    |> where([t], t.person_id == ^person.id)
    |> Repo.all(prefix: Triplex.to_prefix(tenant))
    |> Repo.preload([:person, :competence, :level])
  end

  def get_person_competence_level!(id, tenant) do
    Repo.get!(PersonCompetenceLevel, id, prefix: Triplex.to_prefix(tenant))
    |> Repo.preload([:person, :competence, :level])
  end

  def create_person_competence_level(attrs \\ %{}, tenant) do
    %PersonCompetenceLevel{}
    |> PersonCompetenceLevel.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  def update_person_competence_level(
        %PersonCompetenceLevel{} = person_competence_level,
        attrs,
        tenant
      ) do
    person_competence_level
    |> PersonCompetenceLevel.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(tenant))
  end

  def delete_person_competence_level(%PersonCompetenceLevel{} = person_competence_level, tenant) do
    Repo.delete(person_competence_level, prefix: Triplex.to_prefix(tenant))
  end

  def change_person_competence_level(%PersonCompetenceLevel{} = person_competence_level) do
    PersonCompetenceLevel.changeset(person_competence_level, %{})
  end
end
