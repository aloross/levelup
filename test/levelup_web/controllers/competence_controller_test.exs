defmodule LevelupWeb.CompetenceControllerTest do
  use LevelupWeb.ConnCase
  use Levelup.TenantCase

  import Levelup.TenantFactory

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "Prevent unauthorized access" do
    setup [:create_competence]

    test "index competences", %{conn: conn} do
      conn = get(conn, Routes.competence_path(conn, :index))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new competence form", %{conn: conn} do
      conn = get(conn, Routes.competence_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "new competence", %{conn: conn} do
      conn = post(conn, Routes.competence_path(conn, :create), competence: @create_attrs)
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit competence form", %{conn: conn, competence: competence} do
      conn = get(conn, Routes.competence_path(conn, :edit, competence))
      assert html_response(conn, 302) =~ "redirected"
    end

    test "edit competence valid", %{conn: conn, competence: competence} do
      conn =
        put(conn, Routes.competence_path(conn, :update, competence), competence: @update_attrs)

      assert html_response(conn, 302) =~ "redirected"
    end

    test "deletes competence", %{conn: conn, competence: competence} do
      conn = delete(conn, Routes.competence_path(conn, :delete, competence))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "index" do
    setup [:as_user]

    test "lists all competences", %{conn: conn} do
      conn = get(conn, Routes.competence_path(conn, :index))
      assert html_response(conn, 200) =~ "Competences"
    end
  end

  describe "new competence" do
    setup [:as_user]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.competence_path(conn, :new))
      assert html_response(conn, 200) =~ "New competence"
    end
  end

  describe "create competence" do
    setup [:as_user]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.competence_path(conn, :create), competence: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.competence_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.competence_path(conn, :create), competence: @invalid_attrs)
      assert html_response(conn, 200) =~ "New competence"
    end
  end

  describe "edit competence" do
    setup [:create_competence, :as_user]

    test "renders form for editing chosen competence", %{conn: conn, competence: competence} do
      conn = get(conn, Routes.competence_path(conn, :edit, competence))
      assert html_response(conn, 200) =~ "Edit #{competence.name}"
    end
  end

  describe "update competence" do
    setup [:create_competence, :as_user]

    test "redirects when data is valid", %{conn: conn, competence: competence} do
      conn =
        put(conn, Routes.competence_path(conn, :update, competence), competence: @update_attrs)

      assert redirected_to(conn) == Routes.competence_path(conn, :show, competence)
    end

    test "renders errors when data is invalid", %{conn: conn, competence: competence} do
      conn =
        put(conn, Routes.competence_path(conn, :update, competence), competence: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit #{competence.name}"
    end
  end

  describe "delete competence" do
    setup [:create_competence, :as_user]

    test "deletes chosen competence", %{conn: conn, competence: competence} do
      conn = delete(conn, Routes.competence_path(conn, :delete, competence))
      assert redirected_to(conn) == Routes.competence_path(conn, :index)
    end
  end

  defp create_competence(_) do
    competence = insert(:competence)
    {:ok, competence: competence}
  end
end
