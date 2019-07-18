defmodule LevelupWeb.PositionCompetenceLevelControllerTest do
  use LevelupWeb.ConnCase

  alias Levelup.Competences

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:position_competence_level) do
    {:ok, position_competence_level} = Competences.create_position_competence_level(@create_attrs)
    position_competence_level
  end

  describe "index" do
    test "lists all positions_competences_levels", %{conn: conn} do
      conn = get(conn, Routes.position_competence_level_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Positions competences levels"
    end
  end

  describe "new position_competence_level" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.position_competence_level_path(conn, :new))
      assert html_response(conn, 200) =~ "New Position competence level"
    end
  end

  describe "create position_competence_level" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.position_competence_level_path(conn, :create), position_competence_level: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.position_competence_level_path(conn, :show, id)

      conn = get(conn, Routes.position_competence_level_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Position competence level"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.position_competence_level_path(conn, :create), position_competence_level: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Position competence level"
    end
  end

  describe "edit position_competence_level" do
    setup [:create_position_competence_level]

    test "renders form for editing chosen position_competence_level", %{conn: conn, position_competence_level: position_competence_level} do
      conn = get(conn, Routes.position_competence_level_path(conn, :edit, position_competence_level))
      assert html_response(conn, 200) =~ "Edit Position competence level"
    end
  end

  describe "update position_competence_level" do
    setup [:create_position_competence_level]

    test "redirects when data is valid", %{conn: conn, position_competence_level: position_competence_level} do
      conn = put(conn, Routes.position_competence_level_path(conn, :update, position_competence_level), position_competence_level: @update_attrs)
      assert redirected_to(conn) == Routes.position_competence_level_path(conn, :show, position_competence_level)

      conn = get(conn, Routes.position_competence_level_path(conn, :show, position_competence_level))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, position_competence_level: position_competence_level} do
      conn = put(conn, Routes.position_competence_level_path(conn, :update, position_competence_level), position_competence_level: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Position competence level"
    end
  end

  describe "delete position_competence_level" do
    setup [:create_position_competence_level]

    test "deletes chosen position_competence_level", %{conn: conn, position_competence_level: position_competence_level} do
      conn = delete(conn, Routes.position_competence_level_path(conn, :delete, position_competence_level))
      assert redirected_to(conn) == Routes.position_competence_level_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.position_competence_level_path(conn, :show, position_competence_level))
      end
    end
  end

  defp create_position_competence_level(_) do
    position_competence_level = fixture(:position_competence_level)
    {:ok, position_competence_level: position_competence_level}
  end
end
