defmodule Levelup.TenantCase do
  use ExUnit.CaseTemplate

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Levelup.Repo)
    # we are setting :auto here so that the data persists for all tests,
    # normally (with :shared mode) every process runs in a transaction
    # and rolls back when it exits. setup_all runs in a distinct process
    # from each test so the data doesn't exist for each test.
    Ecto.Adapters.SQL.Sandbox.mode(Levelup.Repo, :auto)
    if Triplex.exists?("acme"), do: Triplex.drop("acme")
    {:ok, tenant} = Triplex.create("acme")

    [tenant: tenant]
  end
end
