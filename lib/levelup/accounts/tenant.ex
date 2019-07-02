defmodule Levelup.Accounts.Tenant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Levelup.Accounts.Credential

  schema "tenants" do
    field :slug, :string
    field :title, :string
    has_many :credentials, Credential
    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:slug, :title])
    |> validate_required([:slug, :title])
  end
end
