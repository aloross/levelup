defmodule Levelup.TenantFactory do
  use ExMachina
  use Levelup.TenantStrategy, repo: Levelup.Repo, repo_options: [prefix: "acme"]

  def position_factory do
    %Levelup.Positions.Position{
      name: Faker.Industry.sub_sector()
    }
  end

  def competence_factory do
    %Levelup.Competences.Competence{
      name: Faker.Lorem.word()
    }
  end

  def level_factory do
    %Levelup.Competences.Level{
      name: Faker.Lorem.word()
    }
  end

  def person_factory do
    %Levelup.Persons.Person{
      firstname: Faker.Name.first_name(),
      lastname: Faker.Name.last_name(),
      identifier: Faker.Code.iban()
    }
  end

  def person_competence_level_factory(attrs) do
    person = Map.get(attrs, :person, build(:person))
    competence = Map.get(attrs, :competence, build(:competence))
    level = Map.get(attrs, :level, build(:level))

    %Levelup.Competences.PersonCompetenceLevel{
      person: person,
      competence: competence,
      level: level
    }
  end

  def position_competence_level_factory(attrs) do
    position = Map.get(attrs, :position, build(:position))
    competence = Map.get(attrs, :competence, build(:competence))
    level = Map.get(attrs, :level, build(:level))

    %Levelup.Competences.PositionCompetenceLevel{
      position: position,
      competence: competence,
      level: level
    }
  end
end
