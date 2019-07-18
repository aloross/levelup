defmodule LevelupWeb.PersonCompetenceLevelControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @invalid_attrs %{}

  setup_all [:init_person]
  setup [:as_user]

  describe "index" do
    test "lists all persons_competences_levels", %{conn: conn, person: person} do
      conn = get(conn, Routes.person_competence_path(conn, :index, person))
      assert html_response(conn, 200) =~ "Listing Persons competences levels"
    end
  end

  describe "new person_competence_level" do
    test "renders form", %{conn: conn, person: person} do
      conn = get(conn, Routes.person_competence_path(conn, :new, person))
      assert html_response(conn, 200) =~ "New Person competence level"
    end
  end

  describe "create person_competence_level" do
    test "redirects to show when data is valid", %{conn: conn, person: person} do
      competence = insert(:competence)

      create_attrs = %{
        person_id: person.id,
        competence_id: competence.id
      }

      conn =
        post(conn, Routes.person_competence_path(conn, :create, person),
          person_competence_level: create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.person_competence_path(conn, :show, person, id)
    end

    test "renders errors when data is invalid", %{conn: conn, person: person} do
      conn =
        post(conn, Routes.person_competence_path(conn, :create, person),
          person_competence_level: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New Person competence level"
    end
  end

  describe "edit person_competence_level" do
    setup [:create_person_competence_level]

    test "renders form for editing chosen person_competence_level", %{
      conn: conn,
      person_competence_level: person_competence_level,
      person: person
    } do
      conn =
        get(
          conn,
          Routes.person_competence_path(conn, :edit, person, person_competence_level)
        )

      assert html_response(conn, 200) =~ "Edit Person competence level"
    end
  end

  describe "update person_competence_level" do
    setup [:create_person_competence_level]

    test "redirects when data is valid", %{
      conn: conn,
      person_competence_level: person_competence_level,
      person: person
    } do
      competence = insert(:competence)

      update_attrs = %{
        competence_id: competence.id
      }

      conn =
        put(
          conn,
          Routes.person_competence_path(conn, :update, person, person_competence_level),
          person_competence_level: update_attrs
        )

      assert redirected_to(conn) ==
               Routes.person_competence_path(conn, :show, person, person_competence_level)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      person_competence_level: person_competence_level,
      person: person
    } do
      conn =
        put(
          conn,
          Routes.person_competence_path(conn, :update, person, person_competence_level),
          person_competence_level: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Person competence level"
    end
  end

  describe "delete person_competence_level" do
    setup [:create_person_competence_level]

    test "deletes chosen person_competence_level", %{
      conn: conn,
      person_competence_level: person_competence_level,
      person: person
    } do
      conn =
        delete(
          conn,
          Routes.person_competence_path(conn, :delete, person, person_competence_level)
        )

      assert redirected_to(conn) == Routes.person_competence_path(conn, :index, person)
    end
  end

  defp init_person(_) do
    person = insert(:person)
    [person: person]
  end

  defp create_person_competence_level(_) do
    person_competence_level = insert(:person_competence_level)
    {:ok, person_competence_level: person_competence_level}
  end
end
