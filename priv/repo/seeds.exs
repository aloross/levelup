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

Repo.insert!(%Levelup.Positions.Position{name: "Acme position 1"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Acme position 2"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Acme position 3"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Acme position 4"},
  prefix: Triplex.to_prefix("acme")
)

Repo.insert!(%Levelup.Positions.Position{name: "Acme position 5"},
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
