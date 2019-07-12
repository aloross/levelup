defmodule Levelup.Factory do
  use ExMachina.Ecto, repo: Levelup.Repo

  def credential_factory(attrs) do
    role = Map.get(attrs, :role, nil)
    tenant = Map.get(attrs, :tenant, build(:tenant))

    %Levelup.Accounts.Credential{
      username: Faker.Name.first_name(),
      password: Faker.Lorem.sentence(),
      tenant: tenant,
      role: role
    }
  end

  def tenant_factory(attrs) do
    title = Map.get(attrs, :title, Faker.Company.name())

    %Levelup.Accounts.Tenant{
      title: title,
      slug: Slugger.slugify_downcase(title)
    }
  end
end
