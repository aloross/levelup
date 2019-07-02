defmodule Levelup.Accounts.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Levelup.Repo

  schema "items" do
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:item])
    |> validate_required([:item])
  end

  def all(tenant) do
    Repo.all(__MODULE__, prefix: Triplex.to_prefix(tenant))
  end
end
