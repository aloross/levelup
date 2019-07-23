defmodule LevelupWeb.PositionControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  test "require user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.position_path(conn, :index)),
        get(conn, Routes.position_path(conn, :new)),
        get(conn, Routes.position_path(conn, :show, "1")),
        get(conn, Routes.position_path(conn, :edit, "1")),
        post(conn, Routes.position_path(conn, :create, %{})),
        put(conn, Routes.position_path(conn, :update, "1", %{})),
        delete(conn, Routes.position_path(conn, :delete, "1"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    setup [:as_manager]

    test "lists all positions", %{conn: conn} do
      conn = get(conn, Routes.position_path(conn, :index))
      assert html_response(conn, 200) =~ "Positions"
    end
  end

  describe "new position" do
    setup [:as_manager]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.position_path(conn, :new))
      assert html_response(conn, 200) =~ "New position"
    end
  end

  describe "create position" do
    setup [:as_manager]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.position_path(conn, :create), position: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.position_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.position_path(conn, :create), position: @invalid_attrs)
      assert html_response(conn, 200) =~ "New position"
    end
  end

  describe "edit position" do
    setup [:create_position, :as_manager]

    test "renders form for editing chosen position", %{conn: conn, position: position} do
      conn = get(conn, Routes.position_path(conn, :edit, position))

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape("Edit #{position.name}"))
    end
  end

  describe "update position" do
    setup [:create_position, :as_manager]

    test "redirects when data is valid", %{conn: conn, position: position} do
      conn = put(conn, Routes.position_path(conn, :update, position), position: @update_attrs)
      assert redirected_to(conn) == Routes.position_path(conn, :show, position)
    end

    test "renders errors when data is invalid", %{conn: conn, position: position} do
      conn = put(conn, Routes.position_path(conn, :update, position), position: @invalid_attrs)

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape("Edit #{position.name}"))
    end
  end

  describe "delete position" do
    setup [:create_position, :as_manager]

    test "deletes chosen position", %{conn: conn, position: position} do
      conn = delete(conn, Routes.position_path(conn, :delete, position))
      assert redirected_to(conn) == Routes.position_path(conn, :index)
    end
  end

  defp create_position(_) do
    position = insert(:position)
    {:ok, position: position}
  end
end
