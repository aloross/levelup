defmodule LevelupWeb.PersonCompetenceLevelControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @invalid_attrs %{
    person_id: "i_do_not_exists"
  }

  setup_all [:init_person, :create_person_competence_level]

  test "require user authentication on all actions", %{conn: conn, person: person} do
    Enum.each(
      [
        get(conn, Routes.person_competence_path(conn, :new, person)),
        get(conn, Routes.person_competence_path(conn, :edit, person, "1")),
        post(conn, Routes.person_competence_path(conn, :create, person, %{})),
        put(conn, Routes.person_competence_path(conn, :update, "1", person, %{})),
        delete(conn, Routes.person_competence_path(conn, :delete, person, "1"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "as a logged in user" do
    setup [:as_user]

    test "renders creating form on new", %{conn: conn, person: person} do
      conn = get(conn, Routes.person_competence_path(conn, :new, person))
      assert html_response(conn, 200) =~ "New competence"
    end

    test "creates competence then redirects to related person", %{
      conn: conn,
      person: person
    } do
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
      assert redirected_to(conn) == Routes.person_path(conn, :show, person)
    end

    test "does not create competence then renders errors when invalid", %{
      conn: conn,
      person: person
    } do
      conn =
        post(conn, Routes.person_competence_path(conn, :create, person),
          person_competence_level: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New competence"
    end

    test "renders editing form on edit", %{
      conn: conn,
      person_competence_level: person_competence_level,
      person: person
    } do
      conn =
        get(
          conn,
          Routes.person_competence_path(conn, :edit, person, person_competence_level)
        )

      assert html_response(conn, 200) =~ "Edit competence"
    end

    test "updates competence then redirects to related person", %{
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
               Routes.person_path(conn, :show, person)
    end

    test "does not update competence then renders errors when invalid", %{
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

      assert html_response(conn, 200) =~ "Edit competence"
    end

    test "deletes competence then redirects to related person", %{
      conn: conn,
      person_competence_level: person_competence_level,
      person: person
    } do
      conn =
        delete(
          conn,
          Routes.person_competence_path(conn, :delete, person, person_competence_level)
        )

      assert redirected_to(conn) == Routes.person_path(conn, :show, person)
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
