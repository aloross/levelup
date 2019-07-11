defmodule Levelup.Persons do
  import Ecto.Query, warn: false
  alias Levelup.Repo

  alias Levelup.Persons.Person

  def list_persons(tenant) do
    Repo.all(Person, prefix: Triplex.to_prefix(tenant))
  end

  def get_person!(id, tenant), do: Repo.get!(Person, id, prefix: Triplex.to_prefix(tenant))

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
end
