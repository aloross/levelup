defmodule Levelup.AccountsTest do
  use Levelup.DataCase

  alias Levelup.Accounts
  import Levelup.Factory

  describe "credentials" do
    alias Levelup.Accounts.Credential

    @valid_attrs %{password: "some password", username: "some username"}
    @update_attrs %{password: "some updated password", username: "some updated username"}
    @invalid_attrs %{password: nil, username: nil}

    test "list_credentials/0 returns all credentials" do
      credential = insert(:credential)
      assert Accounts.list_credentials() == [credential]
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = insert(:credential)
      assert Accounts.get_credential!(credential.id) == credential
    end

    test "create_credential/1 with valid data creates a credential" do
      tenant = insert(:tenant)

      assert {:ok, %Credential{} = credential} =
               Accounts.create_credential(
                 Map.merge(@valid_attrs, %{
                   tenant_id: tenant.id
                 })
               )

      assert true == Comeonin.Bcrypt.checkpw("some password", credential.password)
      assert credential.username == "some username"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = insert(:credential)

      assert {:ok, %Credential{} = credential} =
               Accounts.update_credential(credential, @update_attrs)

      assert true == Comeonin.Bcrypt.checkpw("some updated password", credential.password)
      assert credential.username == "some updated username"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = insert(:credential)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
      assert credential == Accounts.get_credential!(credential.id)
    end

    test "delete_credential/1 deletes the credential" do
      credential = insert(:credential)
      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = insert(:credential)
      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end

  describe "tenants" do
    alias Levelup.Accounts.Tenant

    @valid_attrs %{title: "ACME", slug: "acme"}
    @update_attrs %{title: "ACME 2", slug: "acme-2"}
    @invalid_attrs %{title: nil, slug: nil}

    test "list_tenants/0 returns all tenants" do
      tenant = insert(:tenant)
      assert Accounts.list_tenants() == [tenant]
    end

    test "get_tenant!/1 returns the tenant with given id" do
      tenant = insert(:tenant)
      assert Accounts.get_tenant!(tenant.id) == tenant
    end

    test "create_tenant/1 with valid data creates a tenant" do
      assert {:ok, %Tenant{} = tenant} = Accounts.create_tenant(@valid_attrs)
      assert tenant.title == "ACME"
      assert tenant.slug == "acme"
    end

    test "create_tenant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_tenant(@invalid_attrs)
    end

    test "update_tenant/2 with valid data updates the tenant" do
      tenant = insert(:tenant)
      assert {:ok, %Tenant{} = tenant} = Accounts.update_tenant(tenant, @update_attrs)
      assert tenant.title == "ACME 2"
      assert tenant.slug == "acme-2"
    end

    test "update_tenant/2 with invalid data returns error changeset" do
      tenant = insert(:tenant)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_tenant(tenant, @invalid_attrs)
      assert tenant == Accounts.get_tenant!(tenant.id)
    end

    test "delete_tenant/1 deletes the tenant" do
      tenant = insert(:tenant)
      assert {:ok, %Tenant{}} = Accounts.delete_tenant(tenant)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_tenant!(tenant.id) end
    end

    test "change_tenant/1 returns a tenant changeset" do
      tenant = insert(:tenant)
      assert %Ecto.Changeset{} = Accounts.change_tenant(tenant)
    end
  end
end
