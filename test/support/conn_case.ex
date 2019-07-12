defmodule LevelupWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias LevelupWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint LevelupWeb.Endpoint

      defp as_user(%{conn: conn}) do
        tenant =
          Levelup.Repo.insert!(%Levelup.Accounts.Tenant{
            title: "ACME",
            slug: "acme"
          })

        credential =
          Levelup.Repo.insert!(%Levelup.Accounts.Credential{
            username: "user",
            password: "password",
            tenant: tenant
          })

        conn =
          conn
          |> Levelup.Accounts.Guardian.Plug.sign_in(credential)

        {:ok, conn: conn}
      end

      defp as_manager(%{conn: conn}) do
        tenant =
          Levelup.Repo.insert!(%Levelup.Accounts.Tenant{
            title: "ACME",
            slug: "acme"
          })

        credential =
          Levelup.Repo.insert!(%Levelup.Accounts.Credential{
            username: "manager",
            password: "password",
            role: "manager",
            tenant: tenant
          })

        conn =
          conn
          |> Levelup.Accounts.Guardian.Plug.sign_in(credential)

        {:ok, conn: conn}
      end

      defp as_admin(%{conn: conn}) do
        tenant =
          Levelup.Repo.insert!(%Levelup.Accounts.Tenant{
            title: "ACME",
            slug: "acme"
          })

        credential =
          Levelup.Repo.insert!(%Levelup.Accounts.Credential{
            username: "admin",
            password: "password",
            role: "admin",
            tenant: tenant
          })

        conn =
          conn
          |> Levelup.Accounts.Guardian.Plug.sign_in(credential)

        {:ok, conn: conn}
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Levelup.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Levelup.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
