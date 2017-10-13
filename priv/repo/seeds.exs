# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Citybuilder.Repo.insert!(%Citybuilder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

topics = [
  {"RANDOM", :random},
  {"HAPPINESS", :happiness},
  {"HACKING", :hacking},
  {"NEWS", :news},
  {"TECHNOLOGY", :technology},
  {"ART + MUSIC", :art_and_music},
  {"MYSTERIES", :mysteries},
  {"CLASSIC", :classic},
  {"CITY-BUILDING", :city_building},
  {"LONG-LIFE", :long_life}]

countries = [
  {"India", :india},
  {"Colombia", :colombia} #colombia is the Spanish spelling!
]

# Citybuilder.Repo.all Citybuilder.Stories.Topic - see all topics
# Citybuilder.Repo.get_by(Citybuilder.Stories.Topic, slug: "longevity") - get specific topic
# Citybuilder.Repo.get_by(Citybuilder.Stories.Topic, slug: "longevity") |> Ecto.Changeset.change(name: "Long Life") |> Citybuilder.Repo.update! - update topic name.3:56 PM
# To run this console, login to jake, then run
# cd citybuilder
# bin/citybuilder remote_console

Citybuilder.Repo.transaction fn ->
  topics
  |> Enum.with_index
  |> Enum.each(fn({{name, slug}, position}) ->
    slug = Atom.to_string(slug)
    topic = %Citybuilder.Stories.Topic{
      name: name,
      slug: slug,
      position: position
    }
    Citybuilder.Repo.get_by(Citybuilder.Stories.Topic, slug: slug) ||
      Citybuilder.Repo.insert!(topic)
  end)

  countries
  |> Enum.each(fn({name, slug}) ->
    slug = Atom.to_string(slug)
    country = %Citybuilder.Addresses.Country{
      name: name,
      slug: slug
    }
    Citybuilder.Repo.get_by(Citybuilder.Addresses.Country, slug: slug) ||
      Citybuilder.Repo.insert!(country)
  end)
end
