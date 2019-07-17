defmodule LevelupWeb.CompetenceController do
  use LevelupWeb, :controller

  alias Levelup.Competences
  alias Levelup.Competences.Competence

  def index(conn, _params) do
    competences = Competences.list_competences(conn.assigns.current_tenant)
    render(conn, "index.html", competences: competences)
  end

  def new(conn, _params) do
    changeset = Competences.change_competence(%Competence{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"competence" => competence_params}) do
    case Competences.create_competence(competence_params, conn.assigns.current_tenant) do
      {:ok, competence} ->
        conn
        |> put_flash(:info, "Competence created successfully.")
        |> redirect(to: Routes.competence_path(conn, :show, competence))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    competence = Competences.get_competence!(id, conn.assigns.current_tenant)
    render(conn, "show.html", competence: competence)
  end

  def edit(conn, %{"id" => id}) do
    competence = Competences.get_competence!(id, conn.assigns.current_tenant)
    changeset = Competences.change_competence(competence)
    render(conn, "edit.html", competence: competence, changeset: changeset)
  end

  def update(conn, %{"id" => id, "competence" => competence_params}) do
    competence = Competences.get_competence!(id, conn.assigns.current_tenant)

    case Competences.update_competence(competence, competence_params, conn.assigns.current_tenant) do
      {:ok, competence} ->
        conn
        |> put_flash(:info, "Competence updated successfully.")
        |> redirect(to: Routes.competence_path(conn, :show, competence))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", competence: competence, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    competence = Competences.get_competence!(id, conn.assigns.current_tenant)
    {:ok, _competence} = Competences.delete_competence(competence, conn.assigns.current_tenant)

    conn
    |> put_flash(:info, "Competence deleted successfully.")
    |> redirect(to: Routes.competence_path(conn, :index))
  end
end
