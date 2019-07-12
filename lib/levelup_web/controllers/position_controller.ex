defmodule LevelupWeb.PositionController do
  use LevelupWeb, :controller

  alias Levelup.Positions
  alias Levelup.Positions.Position

  def index(conn, _params) do
    positions = Positions.list_positions(conn.assigns.current_tenant)
    render(conn, "index.html", positions: positions)
  end

  def new(conn, _params) do
    changeset = Positions.change_position(%Position{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"position" => position_params}) do
    case Positions.create_position(position_params, conn.assigns.current_tenant) do
      {:ok, position} ->
        conn
        |> put_flash(:info, "Position created successfully.")
        |> redirect(to: Routes.position_path(conn, :show, position))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    position = Positions.get_position!(id, conn.assigns.current_tenant)
    render(conn, "show.html", position: position)
  end

  def edit(conn, %{"id" => id}) do
    position = Positions.get_position!(id, conn.assigns.current_tenant)
    changeset = Positions.change_position(position)
    render(conn, "edit.html", position: position, changeset: changeset)
  end

  def update(conn, %{"id" => id, "position" => position_params}) do
    position = Positions.get_position!(id, conn.assigns.current_tenant)

    case Positions.update_position(position, position_params, conn.assigns.current_tenant) do
      {:ok, position} ->
        conn
        |> put_flash(:info, "Position updated successfully.")
        |> redirect(to: Routes.position_path(conn, :show, position))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", position: position, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    position = Positions.get_position!(id, conn.assigns.current_tenant)
    {:ok, _position} = Positions.delete_position(position, conn.assigns.current_tenant)

    conn
    |> put_flash(:info, "Position deleted successfully.")
    |> redirect(to: Routes.position_path(conn, :index))
  end
end
