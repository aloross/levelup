defmodule Levelup.Persons do
  import Ecto.Query, warn: false
  alias Levelup.Repo

  alias Levelup.Persons.Person

  def list_persons(tenant) do
    Repo.all(Person, prefix: Triplex.to_prefix(tenant)) |> Repo.preload(:position)
  end

  def get_person!(id, tenant) do
    Repo.get!(Person, id, prefix: Triplex.to_prefix(tenant))
    |> Repo.preload(competences: :competence, competences: :level)
    |> Repo.preload(:position)
  end

  def create_person(attrs \\ %{}, tenant) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  def update_person(%Person{} = person, attrs, tenant) do
    person
    |> Person.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(tenant))
  end

  def delete_person(%Person{} = person, tenant) do
    Repo.delete(person, prefix: Triplex.to_prefix(tenant))
  end

  def change_person(%Person{} = person) do
    Person.changeset(person, %{})
  end

  def list_matching_positions(id, tenant) do
    person = get_person!(id, tenant)

    competence_ids =
      person.competences
      |> Enum.map(fn c -> c.competence_id end)

    matching_positions =
      Levelup.Competences.PositionCompetenceLevel
      |> where([pcl], pcl.competence_id in ^competence_ids)
      |> where([pcl], pcl.position_id != ^person.position.id)
      |> distinct([pcl], pcl.position_id)
      |> Repo.all(prefix: Triplex.to_prefix(tenant))
      |> Repo.preload(position: [competences: :competence])
      |> Enum.map(fn pcl ->
        score = compute_matching_score(pcl, competence_ids)
        %{position: pcl.position, score: score}
      end)
      |> Enum.sort(fn match1, match2 -> match1.score >= match2.score end)

    IO.inspect(matching_positions)
    matching_positions
  end

  defp compute_matching_score(pcl, competence_ids) do
    step = 100 / Enum.count(pcl.position.competences)

    Enum.reduce(pcl.position.competences, 0, fn c, acc ->
      case Enum.find(competence_ids, fn c_id -> c_id == c.competence_id end) do
        nil -> acc
        _ -> acc + step
      end
    end)
  end
end
