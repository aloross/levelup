defmodule LevelupWeb.AdminControllerTest do
  use LevelupWeb.ConnCase

  describe "Prevent unauthorized access" do
    setup [:as_manager]

    test "index admin", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "index" do
    setup [:as_admin]

    test "show for admin user", %{conn: conn} do
      conn = get(conn, Routes.admin_path(conn, :index))

      assert html_response(conn, 200) =~ "Administration"
    end
  end
end
