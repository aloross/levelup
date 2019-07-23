defmodule LevelupWeb.LevelControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  test "require user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.level_path(conn, :index)),
        get(conn, Routes.level_path(conn, :new)),
        get(conn, Routes.level_path(conn, :show, "1")),
        get(conn, Routes.level_path(conn, :edit, "1")),
        post(conn, Routes.level_path(conn, :create, %{})),
        put(conn, Routes.level_path(conn, :update, "1", %{})),
        delete(conn, Routes.level_path(conn, :delete, "1"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
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

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape("Edit #{level.name}"))
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

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape("Edit #{level.name}"))
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
