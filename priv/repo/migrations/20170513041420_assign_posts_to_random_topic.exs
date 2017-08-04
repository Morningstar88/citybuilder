defmodule Citybuilder.Repo.Migrations.AssignPostsToRandomTopic do
  use Ecto.Migration

  alias Citybuilder.Repo
  alias Citybuilder.Stories.Topic

  def change do
    # Using Elixir schemas just to be really quick
    # Fix it if broken, use SQL queries
    topic = Repo.get_by(Topic, slug: "random")
    if topic do
      execute "UPDATE stories_posts SET topic_id=#{topic.id}"
    end
  end
end
