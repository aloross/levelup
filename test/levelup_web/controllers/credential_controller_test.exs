defmodule LevelupWeb.CredentialControllerTest do
  use LevelupWeb.ConnCase

  alias Levelup.Accounts
  import Levelup.Factory

  @create_attrs %{password: "some password", username: "some username"}
  @update_attrs %{password: "some updated password", username: "some updated username"}
  @invalid_attrs %{password: nil, username: nil}

  def fixture(:credential) do
    {:ok, credential} = Accounts.create_credential(@create_attrs)
    credential
  end

  describe "Prevent unauthorized access" do
    setup [:create_credential, :as_user]

    test "index credentials", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new credential form", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new credential", %{conn: conn} do
      conn = post(conn, Routes.credential_path(conn, :create), credential: @create_attrs)
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit credential form", %{conn: conn, credential: credential} do
      conn = get(conn, Routes.credential_path(conn, :edit, credential))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit credential valid", %{conn: conn, credential: credential} do
      conn =
        put(conn, Routes.credential_path(conn, :update, credential), credential: @update_attrs)

      assert html_response(conn, 302) =~ "redirected"
    end

    test "deletes credential", %{conn: conn, credential: credential} do
      conn = delete(conn, Routes.credential_path(conn, :delete, credential))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "index" do
    setup [:as_manager]

    test "lists all credentials", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Credentials"
    end
  end

  describe "new credential" do
    setup [:as_manager]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :new))
      assert html_response(conn, 200) =~ "New Credential"
    end
  end

  describe "create credential" do
    setup [:as_manager]

    test "redirects to show when data is valid", %{conn: conn} do
      tenant = insert(:tenant)

      conn =
        post(conn, Routes.credential_path(conn, :create),
          credential:
            Map.merge(@create_attrs, %{
              tenant_id: tenant.id
            })
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.credential_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.credential_path(conn, :create), credential: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Credential"
    end
  end

  describe "edit credential" do
    setup [:as_manager, :create_credential]

    test "renders form for editing chosen credential", %{conn: conn, credential: credential} do
      conn = get(conn, Routes.credential_path(conn, :edit, credential))
      assert html_response(conn, 200) =~ "Edit Credential"
    end
  end

  describe "update credential" do
    setup [:create_credential, :as_manager]

    test "redirects when data is valid", %{conn: conn, credential: credential} do
      conn =
        put(conn, Routes.credential_path(conn, :update, credential), credential: @update_attrs)

      assert redirected_to(conn) == Routes.credential_path(conn, :show, credential)
    end

    test "renders errors when data is invalid", %{conn: conn, credential: credential} do
      conn =
        put(conn, Routes.credential_path(conn, :update, credential), credential: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Credential"
    end
  end

  describe "delete credential" do
    setup [:as_manager, :create_credential]

    test "deletes chosen credential", %{conn: conn, credential: credential} do
      conn = delete(conn, Routes.credential_path(conn, :delete, credential))
      assert redirected_to(conn) == Routes.credential_path(conn, :index)
    end
  end

  defp create_credential(_) do
    tenant = insert(:tenant)
    credential = insert(:credential, %{tenant_id: tenant.id})
    {:ok, credential: credential}
  end
end
