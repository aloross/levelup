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

  test "require user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.credential_path(conn, :index)),
        get(conn, Routes.credential_path(conn, :new)),
        get(conn, Routes.credential_path(conn, :show, "1")),
        get(conn, Routes.credential_path(conn, :edit, "1")),
        post(conn, Routes.credential_path(conn, :create, %{})),
        put(conn, Routes.credential_path(conn, :update, "1", %{})),
        delete(conn, Routes.credential_path(conn, :delete, "1"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    setup [:as_manager]

    test "lists all credentials", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :index))

      assert html_response(conn, 200) =~ "Credentials"
    end
  end

  describe "new credential" do
    setup [:as_manager]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.credential_path(conn, :new))
      assert html_response(conn, 200) =~ "New credential"
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
      assert html_response(conn, 200) =~ "New credential"
    end
  end

  describe "edit credential" do
    setup [:as_manager, :create_credential]

    test "renders form for editing chosen credential", %{conn: conn, credential: credential} do
      conn = get(conn, Routes.credential_path(conn, :edit, credential))

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(
                 Phoenix.HTML.html_escape("Edit #{credential.username}")
               )
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

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(
                 Phoenix.HTML.html_escape("Edit #{credential.username}")
               )
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
