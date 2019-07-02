import Ecto.Query
alias Levelup.Repo
alias Levelup.Account

Triplex.drop("acme")
Triplex.drop("emca")

Repo.query!("TRUNCATE credentials CASCADE", [])
Repo.query!("TRUNCATE tenants CASCADE", [])

acme = Repo.insert!(%Levelup.Account.Tenant{slug: "acme", title: "ACME"})
emca = Repo.insert!(%Levelup.Account.Tenant{slug: "emca", title: "EMCA"})

Triplex.create("acme")
Triplex.create("emca")

Account.create_credential(%{username: "adrien", password: "password", tenant_id: acme.id})
Account.create_credential(%{username: "diane", password: "password", tenant_id: acme.id})
Account.create_credential(%{username: "bobby", password: "password", tenant_id: emca.id})

Repo.insert!(%Levelup.Account.Item{name: "Acme product 1"}, prefix: Triplex.to_prefix("acme"))
Repo.insert!(%Levelup.Account.Item{name: "Acme product 2"}, prefix: Triplex.to_prefix("acme"))
Repo.insert!(%Levelup.Account.Item{name: "Acme product 3"}, prefix: Triplex.to_prefix("acme"))
Repo.insert!(%Levelup.Account.Item{name: "Acme product 4"}, prefix: Triplex.to_prefix("acme"))
Repo.insert!(%Levelup.Account.Item{name: "Acme product 5"}, prefix: Triplex.to_prefix("acme"))

Repo.insert!(%Levelup.Account.Item{name: "Emca product 1"}, prefix: Triplex.to_prefix("emca"))
Repo.insert!(%Levelup.Account.Item{name: "Emca product 2"}, prefix: Triplex.to_prefix("emca"))
Repo.insert!(%Levelup.Account.Item{name: "Emca product 3"}, prefix: Triplex.to_prefix("emca"))
Repo.insert!(%Levelup.Account.Item{name: "Emca product 4"}, prefix: Triplex.to_prefix("emca"))
Repo.insert!(%Levelup.Account.Item{name: "Emca product 5"}, prefix: Triplex.to_prefix("emca"))
