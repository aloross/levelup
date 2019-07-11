defmodule LevelupWeb.PositionControllerTest do
  use LevelupWeb.ConnCase

  alias Levelup.Positions

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:position) do
    {:ok, position} = Positions.create_position(@create_attrs)
    position
  end

  describe "index" do
    test "lists all positions", %{conn: conn} do
      conn = get(conn, Routes.position_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Positions"
    end
  end

  describe "new position" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.position_path(conn, :new))
      assert html_response(conn, 200) =~ "New Position"
    end
  end

  describe "create position" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.position_path(conn, :create), position: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.position_path(conn, :show, id)

      conn = get(conn, Routes.position_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Position"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.position_path(conn, :create), position: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Position"
    end
  end

  describe "edit position" do
    setup [:create_position]

    test "renders form for editing chosen position", %{conn: conn, position: position} do
      conn = get(conn, Routes.position_path(conn, :edit, position))
      assert html_response(conn, 200) =~ "Edit Position"
    end
  end

  describe "update position" do
    setup [:create_position]

    test "redirects when data is valid", %{conn: conn, position: position} do
      conn = put(conn, Routes.position_path(conn, :update, position), position: @update_attrs)
      assert redirected_to(conn) == Routes.position_path(conn, :show, position)

      conn = get(conn, Routes.position_path(conn, :show, position))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, position: position} do
      conn = put(conn, Routes.position_path(conn, :update, position), position: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Position"
    end
  end

  describe "delete position" do
    setup [:create_position]

    test "deletes chosen position", %{conn: conn, position: position} do
      conn = delete(conn, Routes.position_path(conn, :delete, position))
      assert redirected_to(conn) == Routes.position_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.position_path(conn, :show, position))
      end
    end
  end

  defp create_position(_) do
    position = fixture(:position)
    {:ok, position: position}
  end
end
