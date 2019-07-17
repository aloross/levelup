defmodule LevelupWeb.LevelController do
  use LevelupWeb, :controller

  alias Levelup.Competences
  alias Levelup.Competences.Level

  def index(conn, _params) do
    levels = Competences.list_levels(conn.assigns.current_tenant)
    render(conn, "index.html", levels: levels)
  end

  def new(conn, _params) do
    changeset = Competences.change_level(%Level{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"level" => level_params}) do
    case Competences.create_level(level_params, conn.assigns.current_tenant) do
      {:ok, level} ->
        conn
        |> put_flash(:info, "Level created successfully.")
        |> redirect(to: Routes.level_path(conn, :show, level))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    level = Competences.get_level!(id, conn.assigns.current_tenant)
    render(conn, "show.html", level: level)
  end

  def edit(conn, %{"id" => id}) do
    level = Competences.get_level!(id, conn.assigns.current_tenant)
    changeset = Competences.change_level(level)
    render(conn, "edit.html", level: level, changeset: changeset)
  end

  def update(conn, %{"id" => id, "level" => level_params}) do
    level = Competences.get_level!(id, conn.assigns.current_tenant)

    case Competences.update_level(level, level_params, conn.assigns.current_tenant) do
      {:ok, level} ->
        conn
        |> put_flash(:info, "Level updated successfully.")
        |> redirect(to: Routes.level_path(conn, :show, level))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", level: level, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    level = Competences.get_level!(id, conn.assigns.current_tenant)
    {:ok, _level} = Competences.delete_level(level, conn.assigns.current_tenant)

    conn
    |> put_flash(:info, "Level deleted successfully.")
    |> redirect(to: Routes.level_path(conn, :index))
  end
end
