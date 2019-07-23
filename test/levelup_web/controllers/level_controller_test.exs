defmodule LevelupWeb.LevelControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "Prevent unauthorized access" do
    setup [:create_level]

    test "index levels", %{conn: conn} do
      conn = get(conn, Routes.level_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new level form", %{conn: conn} do
      conn = get(conn, Routes.level_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new level", %{conn: conn} do
      conn = post(conn, Routes.level_path(conn, :create), level: @create_attrs)
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit level form", %{conn: conn, level: level} do
      conn = get(conn, Routes.level_path(conn, :edit, level))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit level valid", %{conn: conn, level: level} do
      conn = put(conn, Routes.level_path(conn, :update, level), level: @update_attrs)

      assert html_response(conn, 302) =~ "redirected"
    end

    test "deletes level", %{conn: conn, level: level} do
      conn = delete(conn, Routes.level_path(conn, :delete, level))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "index" do
    setup [:as_user]

    test "lists all levels", %{conn: conn} do
      conn = get(conn, Routes.level_path(conn, :index))
      assert html_response(conn, 200) =~ "Levels"
    end
  end

  describe "new level" do
    setup [:as_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.level_path(conn, :new))
      assert html_response(conn, 200) =~ "New level"
    end
  end

  describe "create level" do
    setup [:as_user]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.level_path(conn, :create), level: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.level_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.level_path(conn, :create), level: @invalid_attrs)
      assert html_response(conn, 200) =~ "New level"
    end
  end

  describe "edit level" do
    setup [:create_level, :as_user]

    test "renders form for editing chosen level", %{conn: conn, level: level} do
      conn = get(conn, Routes.level_path(conn, :edit, level))
      assert html_response(conn, 200) =~ "Edit #{level.name}"
    end
  end

  describe "update level" do
    setup [:create_level, :as_user]

    test "redirects when data is valid", %{conn: conn, level: level} do
      conn = put(conn, Routes.level_path(conn, :update, level), level: @update_attrs)
      assert redirected_to(conn) == Routes.level_path(conn, :show, level)
    end

    test "renders errors when data is invalid", %{conn: conn, level: level} do
      conn = put(conn, Routes.level_path(conn, :update, level), level: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit #{level.name}"
    end
  end

  describe "delete level" do
    setup [:create_level, :as_user]

    test "deletes chosen level", %{conn: conn, level: level} do
      conn = delete(conn, Routes.level_path(conn, :delete, level))
      assert redirected_to(conn) == Routes.level_path(conn, :index)
    end
  end

  defp create_level(_) do
    level = insert(:level)
    {:ok, level: level}
  end
end
