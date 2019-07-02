defmodule Levelup.Repo.Migrations.AddTenantIdToCredential do
  use Ecto.Migration

  def change do
    alter table("credentials") do
      add :tenant_id, references(:tenants)
    end
  end
end
