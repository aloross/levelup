defmodule Levelup.Positions do
  import Ecto.Query, warn: false
  alias Levelup.Repo

  alias Levelup.Positions.Position

  def list_positions(tenant) do
    Repo.all(Position, prefix: Triplex.to_prefix(tenant))
  end

  def get_position!(id, tenant) do
    Repo.get!(Position, id, prefix: Triplex.to_prefix(tenant))
    |> Repo.preload(competences: :competence, competences: :level)
    |> Repo.preload(:persons)
  end

  def create_position(attrs \\ %{}, tenant) do
    %Position{}
    |> Position.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  def update_position(%Position{} = position, attrs, tenant) do
    position
    |> Position.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(tenant))
  end

  def delete_position(%Position{} = position, tenant) do
    Repo.delete(position, prefix: Triplex.to_prefix(tenant))
  end

  def change_position(%Position{} = position) do
    Position.changeset(position, %{})
  end

  def list_matching_persons(id, tenant) do
    position = get_position!(id, tenant)

    competence_ids =
      position.competences
      |> Enum.map(fn c -> c.competence_id end)

    matching_persons =
      Levelup.Competences.PersonCompetenceLevel
      |> where([pcl], pcl.competence_id in ^competence_ids)
      |> where([pcl], pcl.person_id not in ^Enum.map(position.persons, &Map.get(&1, :id)))
      |> distinct([pcl], pcl.person_id)
      |> Repo.all(prefix: Triplex.to_prefix(tenant))
      |> Repo.preload(person: [competences: :competence])
      |> Enum.map(fn pcl ->
        score = compute_matching_score(pcl, competence_ids)
        %{person: pcl.person, score: score}
      end)
      |> Enum.sort(fn match1, match2 -> match1.score >= match2.score end)

    matching_persons
  end

  defp compute_matching_score(pcl, competence_ids) do
    step = 100 / Enum.count(competence_ids)

    Enum.reduce(pcl.person.competences, 0, fn c, acc ->
      case Enum.find(competence_ids, fn c_id -> c_id == c.competence_id end) do
        nil -> acc
        _ -> acc + step
      end
    end)
  end
end
