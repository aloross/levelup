defmodule LevelupWeb.PersonController do
  use LevelupWeb, :controller

  alias Levelup.Persons
  alias Levelup.Persons.Person

  def index(conn, _params) do
    persons = Persons.list_persons(conn.assigns.current_tenant)
    render(conn, "index.html", persons: persons)
  end

  def new(conn, _params) do
    changeset = Persons.change_person(%Person{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"person" => person_params}) do
    case Persons.create_person(person_params, conn.assigns.current_tenant) do
      {:ok, person} ->
        conn
        |> put_flash(:success, "Person created successfully.")
        |> redirect(to: Routes.person_path(conn, :show, person))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    person = Persons.get_person!(id, conn.assigns.current_tenant)
    matching_positions = Persons.list_matching_positions(id, conn.assigns.current_tenant)
    render(conn, "show.html", person: person, matching_positions: matching_positions)
  end

  def edit(conn, %{"id" => id}) do
    person = Persons.get_person!(id, conn.assigns.current_tenant)
    changeset = Persons.change_person(person)
    render(conn, "edit.html", person: person, changeset: changeset)
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    person = Persons.get_person!(id, conn.assigns.current_tenant)

    case Persons.update_person(person, person_params, conn.assigns.current_tenant) do
      {:ok, person} ->
        conn
        |> put_flash(:success, "Person updated successfully.")
        |> redirect(to: Routes.person_path(conn, :show, person))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", person: person, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    person = Persons.get_person!(id, conn.assigns.current_tenant)
    {:ok, _person} = Persons.delete_person(person, conn.assigns.current_tenant)

    conn
    |> put_flash(:success, "Person deleted successfully.")
    |> redirect(to: Routes.person_path(conn, :index))
  end
end
