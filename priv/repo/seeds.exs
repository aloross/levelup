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
  username: "adrien",
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

Accounts.create_credential(%{username: "bobby", password: "password", tenant_id: emca.id})

Repo.insert!(%Levelup.Persons.Person{firstname: "Jane", lastname: "Doe", identifier: "JD01"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Persons.Person{firstname: "John", lastname: "Doe", identifier: "JD02"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Persons.Person{firstname: "Jake", lastname: "Doe", identifier: "JD03"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Developer"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Project manager"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Designer"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Devops"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Product owner"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Emca position 1"},
  prefix: Triplex.to_prefix("emca")
)

Repo.insert!(%Levelup.Positions.Position{name: "Emca position 2"},
  prefix: Triplex.to_prefix("emca")
)

Repo.insert!(%Levelup.Positions.Position{name: "Emca position 3"},
  prefix: Triplex.to_prefix("emca")
)

Repo.insert!(%Levelup.Positions.Position{name: "Emca position 4"},
  prefix: Triplex.to_prefix("emca")
)

Repo.insert!(%Levelup.Positions.Position{name: "Emca position 5"},
  prefix: Triplex.to_prefix("emca")
)

Repo.insert!(%Levelup.Competences.Competence{name: "Communication"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Competences.Competence{name: "React"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Competences.Competence{name: "Photoshop"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Competences.Competence{name: "Management"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Competences.Competence{name: "PHP"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Competences.Level{name: "Junior"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Competences.Level{name: "Advanced"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Competences.Level{name: "Expert"},
  prefix: Triplex.to_prefix("acme")
)
