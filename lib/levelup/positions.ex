defmodule Levelup.Positions do
  import Ecto.Query, warn: false
  alias Levelup.Repo

  alias Levelup.Positions.Position

  def list_positions(tenant) do
    Repo.all(Position, prefix: Triplex.to_prefix(tenant))
  end

  def get_position!(id, tenant), do: Repo.get!(Position, id, prefix: Triplex.to_prefix(tenant))

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
end
