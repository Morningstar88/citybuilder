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
  {"NEWS", :news},
  {"HAPPINESS", :happiness},
  {"HACKING", :hacking},
  {"TECHNOLOGY", :technology},
  {"ART + MUSIC", :art_and_music},
  {"MYSTERIES", :mysteries},
  {"CLASSIC", :classic},
]

LiveStory.Repo.transaction fn ->
  topics
  |> Enum.with_index
  |> Enum.each(fn({{name, slug}, position}) ->
    topic = %LiveStory.Stories.Topic{
      name: name,
      slug: Atom.to_string(slug),
      position: position
    }
    LiveStory.Repo.insert! topic
  end)
end
