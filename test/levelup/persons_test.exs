defmodule Levelup.PersonsTest do
  use Levelup.DataCase
  use Levelup.TenantCase

  alias Levelup.Persons
  import Levelup.TenantFactory

  describe "persons" do
    alias Levelup.Persons.Person

    @valid_attrs %{
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

    test "list_persons/0 returns all persons", %{tenant: tenant} do
      person = insert(:person)
      assert Persons.list_persons(tenant) == [person]
    end

    test "get_person!/1 returns the person with given id", %{tenant: tenant} do
      person = insert(:person)
      assert Persons.get_person!(person.id, tenant) == person
    end

    test "create_person/1 with valid data creates a person", %{tenant: tenant} do
      position = insert(:position)

      assert {:ok, %Person{} = person} =
               Persons.create_person(
                 Map.merge(@valid_attrs, %{
                   position_id: position.id
                 }),
                 tenant
               )

      assert person.firstname == "some firstname"
      assert person.identifier == "some identifier"
      assert person.lastname == "some lastname"
    end

    test "create_person/1 with invalid data returns error changeset", %{tenant: tenant} do
      assert {:error, %Ecto.Changeset{}} = Persons.create_person(@invalid_attrs, tenant)
    end

    test "update_person/2 with valid data updates the person", %{tenant: tenant} do
      person = insert(:person)
      assert {:ok, %Person{} = person} = Persons.update_person(person, @update_attrs, tenant)
      assert person.firstname == "some updated firstname"
      assert person.identifier == "some updated identifier"
      assert person.lastname == "some updated lastname"
    end

    test "update_person/2 with invalid data returns error changeset", %{tenant: tenant} do
      person = insert(:person)
      assert {:error, %Ecto.Changeset{}} = Persons.update_person(person, @invalid_attrs, tenant)
      assert person == Persons.get_person!(person.id, tenant)
    end

    test "delete_person/1 deletes the person", %{tenant: tenant} do
      person = insert(:person)
      assert {:ok, %Person{}} = Persons.delete_person(person, tenant)
      assert_raise Ecto.NoResultsError, fn -> Persons.get_person!(person.id, tenant) end
    end

    test "change_person/1 returns a person changeset" do
      person = insert(:person)
      assert %Ecto.Changeset{} = Persons.change_person(person)
    end
  end
end
