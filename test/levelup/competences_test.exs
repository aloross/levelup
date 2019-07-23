defmodule Levelup.CompetencesTest do
  use Levelup.DataCase
  use Levelup.TenantCase

  alias Levelup.Competences
  import Levelup.TenantFactory

  describe "competences" do
    alias Levelup.Competences.Competence

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_competences/0 returns all competences", %{tenant: tenant} do
      competence = insert(:competence)
      assert Competences.list_competences(tenant) == [competence]
    end

    test "get_competence!/1 returns the competence with given id", %{tenant: tenant} do
      competence = insert(:competence)
      assert Competences.get_competence!(competence.id, tenant) == competence
    end

    test "create_competence/1 with valid data creates a competence", %{tenant: tenant} do
      assert {:ok, %Competence{} = competence} =
               Competences.create_competence(@valid_attrs, tenant)

      assert competence.name == "some name"
    end

    test "create_competence/1 with invalid data returns error changeset", %{tenant: tenant} do
      assert {:error, %Ecto.Changeset{}} = Competences.create_competence(@invalid_attrs, tenant)
    end

    test "update_competence/2 with valid data updates the competence", %{tenant: tenant} do
      competence = insert(:competence)

      assert {:ok, %Competence{} = competence} =
               Competences.update_competence(competence, @update_attrs, tenant)

      assert competence.name == "some updated name"
    end

    test "update_competence/2 with invalid data returns error changeset", %{tenant: tenant} do
      competence = insert(:competence)

      assert {:error, %Ecto.Changeset{}} =
               Competences.update_competence(competence, @invalid_attrs, tenant)

      assert competence == Competences.get_competence!(competence.id, tenant)
    end

    test "delete_competence/1 deletes the competence", %{tenant: tenant} do
      competence = insert(:competence)
      assert {:ok, %Competence{}} = Competences.delete_competence(competence, tenant)

      assert_raise Ecto.NoResultsError, fn ->
        Competences.get_competence!(competence.id, tenant)
      end
    end

    test "change_competence/1 returns a competence changeset" do
      competence = insert(:competence)
      assert %Ecto.Changeset{} = Competences.change_competence(competence)
    end
  end

  describe "levels" do
    alias Levelup.Competences.Level

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_levels/0 returns all levels", %{tenant: tenant} do
      level = insert(:level)
      assert Competences.list_levels(tenant) == [level]
    end

    test "get_level!/1 returns the level with given id", %{tenant: tenant} do
      level = insert(:level)
      assert Competences.get_level!(level.id, tenant) == level
    end

    test "create_level/1 with valid data creates a level", %{tenant: tenant} do
      assert {:ok, %Level{} = level} = Competences.create_level(@valid_attrs, tenant)
      assert level.name == "some name"
    end

    test "create_level/1 with invalid data returns error changeset", %{tenant: tenant} do
      assert {:error, %Ecto.Changeset{}} = Competences.create_level(@invalid_attrs, tenant)
    end

    test "update_level/2 with valid data updates the level", %{tenant: tenant} do
      level = insert(:level)
      assert {:ok, %Level{} = level} = Competences.update_level(level, @update_attrs, tenant)
      assert level.name == "some updated name"
    end

    test "update_level/2 with invalid data returns error changeset", %{tenant: tenant} do
      level = insert(:level)
      assert {:error, %Ecto.Changeset{}} = Competences.update_level(level, @invalid_attrs, tenant)
      assert level == Competences.get_level!(level.id, tenant)
    end

    test "delete_level/1 deletes the level", %{tenant: tenant} do
      level = insert(:level)
      assert {:ok, %Level{}} = Competences.delete_level(level, tenant)
      assert_raise Ecto.NoResultsError, fn -> Competences.get_level!(level.id, tenant) end
    end

    test "change_level/1 returns a level changeset" do
      level = insert(:level)
      assert %Ecto.Changeset{} = Competences.change_level(level)
    end
  end

  describe "positions_competences_levels" do
    alias Levelup.Competences.PositionCompetenceLevel

    @invalid_attrs %{position_id: nil}

    defp valid_payload(:position) do
      position = insert(:position)
      competence = insert(:competence)
      level = insert(:level)

      %{
        position_id: position.id,
        competence_id: competence.id,
        level_id: level.id
      }
    end

    test "list_positions_competences_levels/0 returns all positions_competences_levels", %{
      tenant: tenant
    } do
      position = insert(:position)
      insert(:position_competence_level, %{position: position})

      assert Enum.count(Competences.list_positions_competences_levels(position, tenant)) == 1
    end

    test "get_position_competence_level!/1 returns the position_competence_level with given id",
         %{tenant: tenant} do
      position_competence_level = insert(:position_competence_level)

      assert Competences.get_position_competence_level!(position_competence_level.id, tenant) ==
               position_competence_level
    end

    test "create_position_competence_level/1 with valid data creates a position_competence_level",
         %{tenant: tenant} do
      assert {:ok, %PositionCompetenceLevel{} = position_competence_level} =
               Competences.create_position_competence_level(valid_payload(:position), tenant)
    end

    test "create_position_competence_level/1 with invalid data returns error changeset", %{
      tenant: tenant
    } do
      assert {:error, %Ecto.Changeset{}} =
               Competences.create_position_competence_level(@invalid_attrs, tenant)
    end

    test "update_position_competence_level/2 with valid data updates the position_competence_level",
         %{tenant: tenant} do
      position_competence_level = insert(:position_competence_level)

      assert {:ok, %PositionCompetenceLevel{} = position_competence_level} =
               Competences.update_position_competence_level(
                 position_competence_level,
                 valid_payload(:position),
                 tenant
               )
    end

    test "update_position_competence_level/2 with invalid data returns error changeset", %{
      tenant: tenant
    } do
      position_competence_level = insert(:position_competence_level)

      assert {:error, %Ecto.Changeset{}} =
               Competences.update_position_competence_level(
                 position_competence_level,
                 @invalid_attrs,
                 tenant
               )

      assert position_competence_level ==
               Competences.get_position_competence_level!(position_competence_level.id, tenant)
    end

    test "delete_position_competence_level/1 deletes the position_competence_level", %{
      tenant: tenant
    } do
      position_competence_level = insert(:position_competence_level)

      assert {:ok, %PositionCompetenceLevel{}} =
               Competences.delete_position_competence_level(position_competence_level, tenant)

      assert_raise Ecto.NoResultsError, fn ->
        Competences.get_position_competence_level!(position_competence_level.id, tenant)
      end
    end

    test "change_position_competence_level/1 returns a position_competence_level changeset" do
      position_competence_level = insert(:position_competence_level)

      assert %Ecto.Changeset{} =
               Competences.change_position_competence_level(position_competence_level)
    end
  end

  describe "persons_competences_levels" do
    alias Levelup.Competences.PersonCompetenceLevel

    @invalid_attrs %{person_id: nil}

    defp valid_payload(:person) do
      person = insert(:person)
      competence = insert(:competence)
      level = insert(:level)

      %{
        person_id: person.id,
        competence_id: competence.id,
        level_id: level.id
      }
    end

    test "list_persons_competences_levels/0 returns all persons_competences_levels", %{
      tenant: tenant
    } do
      person = insert(:person)
      insert(:person_competence_level, %{person: person})

      assert Enum.count(Competences.list_persons_competences_levels(person, tenant)) == 1
    end

    test "get_person_competence_level!/1 returns the person_competence_level with given id", %{
      tenant: tenant
    } do
      person_competence_level = insert(:person_competence_level)

      assert Competences.get_person_competence_level!(person_competence_level.id, tenant) ==
               person_competence_level
    end

    test "create_person_competence_level/1 with valid data creates a person_competence_level", %{
      tenant: tenant
    } do
      assert {:ok, %PersonCompetenceLevel{} = person_competence_level} =
               Competences.create_person_competence_level(valid_payload(:person), tenant)
    end

    test "create_person_competence_level/1 with invalid data returns error changeset", %{
      tenant: tenant
    } do
      assert {:error, %Ecto.Changeset{}} =
               Competences.create_person_competence_level(@invalid_attrs, tenant)
    end

    test "update_person_competence_level/2 with valid data updates the person_competence_level",
         %{
           tenant: tenant
         } do
      person_competence_level = insert(:person_competence_level)

      assert {:ok, %PersonCompetenceLevel{} = person_competence_level} =
               Competences.update_person_competence_level(
                 person_competence_level,
                 valid_payload(:person),
                 tenant
               )
    end

    test "update_person_competence_level/2 with invalid data returns error changeset", %{
      tenant: tenant
    } do
      person_competence_level = insert(:person_competence_level)

      assert {:error, %Ecto.Changeset{}} =
               Competences.update_person_competence_level(
                 person_competence_level,
                 @invalid_attrs,
                 tenant
               )

      assert person_competence_level ==
               Competences.get_person_competence_level!(person_competence_level.id, tenant)
    end

    test "delete_person_competence_level/1 deletes the person_competence_level", %{
      tenant: tenant
    } do
      person_competence_level = insert(:person_competence_level)

      assert {:ok, %PersonCompetenceLevel{}} =
               Competences.delete_person_competence_level(person_competence_level, tenant)

      assert_raise Ecto.NoResultsError, fn ->
        Competences.get_person_competence_level!(person_competence_level.id, tenant)
      end
    end

    test "change_person_competence_level/1 returns a person_competence_level changeset" do
      person_competence_level = insert(:person_competence_level)

      assert %Ecto.Changeset{} =
               Competences.change_person_competence_level(person_competence_level)
    end
  end
end
