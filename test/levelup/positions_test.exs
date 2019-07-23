defmodule Levelup.PositionsTest do
  use Levelup.DataCase
  use Levelup.TenantCase

  alias Levelup.Positions
  import Levelup.TenantFactory

  describe "positions" do
    alias Levelup.Positions.Position

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_positions/0 returns all positions", %{tenant: tenant} do
      position = insert(:position)
      assert Positions.list_positions(tenant) == [position]
    end

    test "get_position!/1 returns the position with given id", %{tenant: tenant} do
      position = insert(:position) |> Repo.preload(:competences)

      assert Positions.get_position!(position.id, tenant) == position
    end

    test "create_position/1 with valid data creates a position", %{tenant: tenant} do
      assert {:ok, %Position{} = position} = Positions.create_position(@valid_attrs, tenant)
      assert position.name == "some name"
    end

    test "create_position/1 with invalid data returns error changeset", %{tenant: tenant} do
      assert {:error, %Ecto.Changeset{}} = Positions.create_position(@invalid_attrs, tenant)
    end

    test "update_position/2 with valid data updates the position", %{tenant: tenant} do
      position = insert(:position) |> Repo.preload(:competences)

      assert {:ok, %Position{} = position} =
               Positions.update_position(position, @update_attrs, tenant)

      assert position.name == "some updated name"
    end

    test "update_position/2 with invalid data returns error changeset", %{tenant: tenant} do
      position = insert(:position) |> Repo.preload(:competences)

      assert {:error, %Ecto.Changeset{}} =
               Positions.update_position(position, @invalid_attrs, tenant)

      assert position == Positions.get_position!(position.id, tenant)
    end

    test "delete_position/1 deletes the position", %{tenant: tenant} do
      position = insert(:position)
      assert {:ok, %Position{}} = Positions.delete_position(position, tenant)
      assert_raise Ecto.NoResultsError, fn -> Positions.get_position!(position.id, tenant) end
    end

    test "change_position/1 returns a position changeset" do
      position = insert(:position)
      assert %Ecto.Changeset{} = Positions.change_position(position)
    end
  end
end
