defmodule Levelup.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias Levelup.Accounts.Tenant

  schema "credentials" do
    field :password, :string
    field :username, :string
    field :role, :string
    belongs_to :tenant, Tenant
    timestamps()
  end

  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:username, :password, :tenant_id, :role])
    |> validate_required([:username, :password, :tenant_id])
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
