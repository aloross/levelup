defmodule Levelup.TenantFactory do
  use ExMachina
  use Levelup.TenantStrategy, repo: Levelup.Repo, repo_options: [prefix: "acme"]

  def position_factory do
    %Levelup.Positions.Position{
      name: Faker.Industry.sub_sector()
    }
  end

  def person_factory do
    %Levelup.Persons.Person{
      firstname: Faker.Name.first_name(),
      lastname: Faker.Name.last_name(),
      identifier: Faker.Code.iban()
    }
  end
end
