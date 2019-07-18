defmodule LevelupWeb.PositionCompetenceLevelController do
  use LevelupWeb, :controller

  alias Levelup.Positions
  alias Levelup.Competences
  alias Levelup.Competences.PositionCompetenceLevel

  def action(conn, _) do
    person = Positions.get_position!(conn.params["position_id"], conn.assigns.current_tenant)
    args = [conn, conn.params, person]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, position) do
    changeset = Competences.change_position_competence_level(%PositionCompetenceLevel{})

    %{competences: competences, levels: levels} =
      Competences.list_competence_and_level_options(conn.assigns.current_tenant)

    render(conn, "new.html",
      changeset: changeset,
      position: position,
      competences: competences,
      levels: levels
    )
  end

  def create(conn, %{"position_competence_level" => position_competence_level_params}, position) do
    case Competences.create_position_competence_level(
           position_competence_level_params,
           conn.assigns.current_tenant
         ) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Position competence level created successfully.")
        |> redirect(to: Routes.position_path(conn, :show, position))

      {:error, %Ecto.Changeset{} = changeset} ->
        %{competences: competences, levels: levels} =
          Competences.list_competence_and_level_options(conn.assigns.current_tenant)

        render(conn, "new.html",
          changeset: changeset,
          position: position,
          competences: competences,
          levels: levels
        )
    end
  end

  def edit(conn, %{"id" => id}, position) do
    position_competence_level =
      Competences.get_position_competence_level!(id, conn.assigns.current_tenant)

    changeset = Competences.change_position_competence_level(position_competence_level)

    %{competences: competences, levels: levels} =
      Competences.list_competence_and_level_options(conn.assigns.current_tenant)

    render(conn, "edit.html",
      position_competence_level: position_competence_level,
      changeset: changeset,
      position: position,
      competences: competences,
      levels: levels
    )
  end

  def update(
        conn,
        %{"id" => id, "position_competence_level" => position_competence_level_params},
        position
      ) do
    position_competence_level =
      Competences.get_position_competence_level!(id, conn.assigns.current_tenant)

    case Competences.update_position_competence_level(
           position_competence_level,
           position_competence_level_params,
           conn.assigns.current_tenant
         ) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Position competence level updated successfully.")
        |> redirect(
          to:
            Routes.position_path(
              conn,
              :show,
              position
            )
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        %{competences: competences, levels: levels} =
          Competences.list_competence_and_level_options(conn.assigns.current_tenant)

        render(conn, "edit.html",
          position_competence_level: position_competence_level,
          changeset: changeset,
          position: position,
          competences: competences,
          levels: levels
        )
    end
  end

  def delete(conn, %{"id" => id}, position) do
    position_competence_level =
      Competences.get_position_competence_level!(id, conn.assigns.current_tenant)

    {:ok, _} =
      Competences.delete_position_competence_level(
        position_competence_level,
        conn.assigns.current_tenant
      )

    conn
    |> put_flash(:info, "Position competence level deleted successfully.")
    |> redirect(to: Routes.position_path(conn, :show, position))
  end
end
