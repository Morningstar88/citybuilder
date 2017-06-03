# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveStory.Repo.insert!(%LiveStory.SomeSchema{})
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
  {"LONGEVITY", :longevity}]

LiveStory.Repo.transaction fn ->
  topics
  |> Enum.with_index
  |> Enum.each(fn({{name, slug}, position}) ->
    slug = Atom.to_string(slug)
    topic = %LiveStory.Stories.Topic{
      name: name,
      slug: slug,
      position: position
    }
    LiveStory.Repo.get_by(LiveStory.Stories.Topic, slug: slug) ||
      LiveStory.Repo.insert!(topic)
  end)
end
