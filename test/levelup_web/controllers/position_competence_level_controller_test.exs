defmodule LevelupWeb.PositionCompetenceLevelControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @invalid_attrs %{
    position_id: "i_do_not_exists"
  }

  setup_all [:init_position]
  setup [:as_user]

  describe "new position_competence_level" do
    test "renders form", %{conn: conn, position: position} do
      conn = get(conn, Routes.position_competence_path(conn, :new, position))
      assert html_response(conn, 200) =~ "New competence"
    end
  end

  describe "create position_competence_level" do
    test "redirects to parent position when data is valid", %{conn: conn, position: position} do
      competence = insert(:competence)

      create_attrs = %{
        position_id: position.id,
        competence_id: competence.id
      }

      conn =
        post(conn, Routes.position_competence_path(conn, :create, position),
          position_competence_level: create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.position_path(conn, :show, position)
    end

    test "renders errors when data is invalid", %{conn: conn, position: position} do
      conn =
        post(conn, Routes.position_competence_path(conn, :create, position),
          position_competence_level: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New competence"
    end
  end

  describe "edit position_competence_level" do
    setup [:create_position_competence_level]

    test "renders form for editing chosen position_competence_level", %{
      conn: conn,
      position_competence_level: position_competence_level,
      position: position
    } do
      conn =
        get(
          conn,
          Routes.position_competence_path(conn, :edit, position, position_competence_level)
        )

      assert html_response(conn, 200) =~ "Edit competence"
    end
  end

  describe "update position_competence_level" do
    setup [:create_position_competence_level]

    test "redirects when data is valid", %{
      conn: conn,
      position_competence_level: position_competence_level,
      position: position
    } do
      competence = insert(:competence)

      update_attrs = %{
        position_id: position.id,
        competence_id: competence.id
      }

      conn =
        put(
          conn,
          Routes.position_competence_path(conn, :update, position, position_competence_level),
          position_competence_level: update_attrs
        )

      assert redirected_to(conn) ==
               Routes.position_path(conn, :show, position)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      position_competence_level: position_competence_level,
      position: position
    } do
      conn =
        put(
          conn,
          Routes.position_competence_path(conn, :update, position, position_competence_level),
          position_competence_level: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit competence"
    end
  end

  describe "delete position_competence_level" do
    setup [:create_position_competence_level]

    test "deletes chosen position_competence_level", %{
      conn: conn,
      position_competence_level: position_competence_level,
      position: position
    } do
      conn =
        delete(
          conn,
          Routes.position_competence_path(conn, :delete, position, position_competence_level)
        )

      assert redirected_to(conn) == Routes.position_path(conn, :show, position)
    end
  end

  defp init_position(_) do
    position = insert(:position)
    [position: position]
  end

  defp create_position_competence_level(_) do
    position_competence_level = insert(:position_competence_level)
    {:ok, position_competence_level: position_competence_level}
  end
end
