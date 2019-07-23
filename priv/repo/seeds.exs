defmodule SeedsHelper do
  alias Levelup.Repo

  def create_level(name, tenant \\ "acme") do
    Repo.insert!(%Levelup.Competences.Level{name: name},
      prefix: Triplex.to_prefix(tenant)
    )
  end

  def create_person(firstname, lastname, identifier, position_id, tenant \\ "acme") do
    Repo.insert!(
      %Levelup.Persons.Person{
        firstname: firstname,
        lastname: lastname,
        identifier: identifier,
        position_id: position_id
      },
      prefix: Triplex.to_prefix(tenant)
    )
  end

  def create_position(name, tenant \\ "acme") do
    Repo.insert!(%Levelup.Positions.Position{name: name},
      prefix: Triplex.to_prefix(tenant)
    )
  end

  def create_competence(name, tenant \\ "acme") do
    Repo.insert!(%Levelup.Competences.Competence{name: name},
      prefix: Triplex.to_prefix(tenant)
    )
  end

  def add_competence_to_person(person_id, competence_id, level_id, tenant \\ "acme") do
    Repo.insert!(
      %Levelup.Competences.PersonCompetenceLevel{
        person_id: person_id,
        competence_id: competence_id,
        level_id: level_id
      },
      prefix: Triplex.to_prefix(tenant)
    )
  end

  def add_competence_to_position(position_id, competence_id, level_id, tenant \\ "acme") do
    Repo.insert!(
      %Levelup.Competences.PositionCompetenceLevel{
        position_id: position_id,
        competence_id: competence_id,
        level_id: level_id
      },
      prefix: Triplex.to_prefix(tenant)
    )
  end
end

alias Levelup.Repo
alias Levelup.Accounts

Triplex.drop("acme")
Triplex.drop("emca")

Repo.query!("TRUNCATE credentials CASCADE", [])
Repo.query!("TRUNCATE tenants CASCADE", [])

acme = Repo.insert!(%Levelup.Accounts.Tenant{slug: "acme", title: "ACME"})
emca = Repo.insert!(%Levelup.Accounts.Tenant{slug: "emca", title: "EMCA"})

Triplex.create("acme")
Triplex.create("emca")

Accounts.create_credential(%{
  username: "admin",
  password: "password",
  tenant_id: acme.id,
  role: "admin"
})

Accounts.create_credential(%{
  username: "diane",
  password: "password",
  tenant_id: acme.id,
  role: "manager"
})

Accounts.create_credential(%{
  username: "adrien",
  password: "password",
  tenant_id: acme.id,
  role: "manager"
})

Accounts.create_credential(%{username: "bobby", password: "password", tenant_id: emca.id})

developer = SeedsHelper.create_position("Developer")
project_manager = SeedsHelper.create_position("Project manager")
designer = SeedsHelper.create_position("Designer")
devops = SeedsHelper.create_position("Devops")
product_owner = SeedsHelper.create_position("Product owner")

jane = SeedsHelper.create_person("Jane", "Doe", "JD01", developer.id)
john = SeedsHelper.create_person("John", "Doe", "JD02", product_owner.id)
jake = SeedsHelper.create_person("Jake", "Doe", "JD03", developer.id)

SeedsHelper.create_position("Emca position 1", "emca")
SeedsHelper.create_position("Emca position 2", "emca")
SeedsHelper.create_position("Emca position 3", "emca")
SeedsHelper.create_position("Emca position 4", "emca")
SeedsHelper.create_position("Emca position 5", "emca")

communication = SeedsHelper.create_competence("Communication")
react = SeedsHelper.create_competence("React")
photoshop = SeedsHelper.create_competence("Photoshop")
management = SeedsHelper.create_competence("Management")
php = SeedsHelper.create_competence("PHP")

junior = SeedsHelper.create_level("Junior")
advanced = SeedsHelper.create_level("Advanced")
expert = SeedsHelper.create_level("Expert")

SeedsHelper.add_competence_to_person(jane.id, photoshop.id, junior.id)
SeedsHelper.add_competence_to_person(jane.id, php.id, advanced.id)
SeedsHelper.add_competence_to_person(john.id, communication.id, expert.id)
SeedsHelper.add_competence_to_person(john.id, management.id, junior.id)
SeedsHelper.add_competence_to_person(jake.id, react.id, expert.id)

SeedsHelper.add_competence_to_position(developer.id, react.id, junior.id)
SeedsHelper.add_competence_to_position(developer.id, php.id, junior.id)
SeedsHelper.add_competence_to_position(project_manager.id, management.id, expert.id)
SeedsHelper.add_competence_to_position(designer.id, photoshop.id, advanced.id)
SeedsHelper.add_competence_to_position(product_owner.id, communication.id, expert.id)
SeedsHelper.add_competence_to_position(product_owner.id, management.id, advanced.id)
