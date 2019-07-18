defmodule LevelupWeb.PersonCompetenceLevelController do
  use LevelupWeb, :controller

  alias Levelup.Competences
  alias Levelup.Persons
  alias Levelup.Competences.PersonCompetenceLevel

  def action(conn, _) do
    person = Persons.get_person!(conn.params["person_id"], conn.assigns.current_tenant)
    args = [conn, conn.params, person]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, person) do
    changeset = Competences.change_person_competence_level(%PersonCompetenceLevel{})

    %{competences: competences, levels: levels} =
      Competences.list_competence_and_level_options(conn.assigns.current_tenant)

    render(conn, "new.html",
      changeset: changeset,
      competences: competences,
      levels: levels,
      person: person
    )
  end

  def create(conn, %{"person_competence_level" => person_competence_level_params}, person) do
    case Competences.create_person_competence_level(
           person_competence_level_params,
           conn.assigns.current_tenant
         ) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Person competence level created successfully.")
        |> redirect(
          to:
            Routes.person_path(
              conn,
              :show,
              person
            )
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        %{competences: competences, levels: levels} =
          Competences.list_competence_and_level_options(conn.assigns.current_tenant)

        render(conn, "new.html",
          changeset: changeset,
          competences: competences,
          levels: levels,
          person: person
        )
    end
  end

  def edit(conn, %{"id" => id}, person) do
    person_competence_level =
      Competences.get_person_competence_level!(id, conn.assigns.current_tenant)

    changeset = Competences.change_person_competence_level(person_competence_level)

    %{competences: competences, levels: levels} =
      Competences.list_competence_and_level_options(conn.assigns.current_tenant)

    render(conn, "edit.html",
      person_competence_level: person_competence_level,
      changeset: changeset,
      competences: competences,
      levels: levels,
      person: person
    )
  end

  def update(
        conn,
        %{"id" => id, "person_competence_level" => person_competence_level_params},
        person
      ) do
    person_competence_level =
      Competences.get_person_competence_level!(id, conn.assigns.current_tenant)

    case Competences.update_person_competence_level(
           person_competence_level,
           person_competence_level_params,
           conn.assigns.current_tenant
         ) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Person competence level updated successfully.")
        |> redirect(
          to:
            Routes.person_path(
              conn,
              :show,
              person
            )
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        %{competences: competences, levels: levels} =
          Competences.list_competence_and_level_options(conn.assigns.current_tenant)

        render(conn, "edit.html",
          person_competence_level: person_competence_level,
          changeset: changeset,
          competences: competences,
          levels: levels,
          person: person
        )
    end
  end

  def delete(conn, %{"id" => id}, person) do
    person_competence_level =
      Competences.get_person_competence_level!(id, conn.assigns.current_tenant)

    {:ok, _person_competence_level} =
      Competences.delete_person_competence_level(
        person_competence_level,
        conn.assigns.current_tenant
      )

    conn
    |> put_flash(:info, "Person competence level deleted successfully.")
    |> redirect(to: Routes.person_path(conn, :show, person))
  end
end
