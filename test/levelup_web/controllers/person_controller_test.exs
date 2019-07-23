defmodule LevelupWeb.PersonControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @create_attrs %{
    firstname: "some firstname",
    identifier: "some identifier",
    lastname: "some lastname"
  }
  @update_attrs %{
    firstname: "some updated firstname",
    identifier: "some updated identifier",
    lastname: "some updated lastname"
  }
  @invalid_attrs %{firstname: nil, identifier: nil, lastname: nil}

  describe "Prevent unauthorized access" do
    setup [:create_person]

    test "index persons", %{conn: conn} do
      conn = get(conn, Routes.person_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new person form", %{conn: conn} do
      conn = get(conn, Routes.person_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new person", %{conn: conn} do
      conn = post(conn, Routes.person_path(conn, :create), person: @create_attrs)
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit person form", %{conn: conn, person: person} do
      conn = get(conn, Routes.person_path(conn, :edit, person))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit person valid", %{conn: conn, person: person} do
      conn = put(conn, Routes.person_path(conn, :update, person), person: @update_attrs)

      assert html_response(conn, 302) =~ "redirected"
    end

    test "deletes person", %{conn: conn, person: person} do
      conn = delete(conn, Routes.person_path(conn, :delete, person))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "index" do
    setup [:as_manager]

    test "lists all persons", %{conn: conn} do
      conn = get(conn, Routes.person_path(conn, :index))
      assert html_response(conn, 200) =~ "Persons"
    end
  end

  describe "new person" do
    setup [:as_manager]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.person_path(conn, :new))
      assert html_response(conn, 200) =~ "New person"
    end
  end

  describe "create person" do
    setup [:as_manager]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.person_path(conn, :create), person: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.person_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.person_path(conn, :create), person: @invalid_attrs)
      assert html_response(conn, 200) =~ "New person"
    end
  end

  describe "edit person" do
    setup [:create_person, :as_manager]

    test "renders form for editing chosen person", %{conn: conn, person: person} do
      conn = get(conn, Routes.person_path(conn, :edit, person))

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(
                 Phoenix.HTML.html_escape(
                   "Edit #{person.firstname} #{person.lastname} (#{person.identifier})"
                 )
               )
    end
  end

  describe "update person" do
    setup [:create_person, :as_manager]

    test "redirects when data is valid", %{conn: conn, person: person} do
      conn = put(conn, Routes.person_path(conn, :update, person), person: @update_attrs)
      assert redirected_to(conn) == Routes.person_path(conn, :show, person)
    end

    test "renders errors when data is invalid", %{conn: conn, person: person} do
      conn = put(conn, Routes.person_path(conn, :update, person), person: @invalid_attrs)

      assert html_response(conn, 200) =~
               Phoenix.HTML.safe_to_string(
                 Phoenix.HTML.html_escape(
                   "Edit #{person.firstname} #{person.lastname} (#{person.identifier})"
                 )
               )
    end
  end

  describe "delete person" do
    setup [:create_person, :as_manager]

    test "deletes chosen person", %{conn: conn, person: person} do
      conn = delete(conn, Routes.person_path(conn, :delete, person))
      assert redirected_to(conn) == Routes.person_path(conn, :index)
    end
  end

  defp create_person(_) do
    person = insert(:person)
    {:ok, person: person}
  end
end
