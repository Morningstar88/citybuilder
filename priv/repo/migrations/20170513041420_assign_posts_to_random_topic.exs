defmodule LiveStory.Repo.Migrations.AssignPostsToRandomTopic do
  use Ecto.Migration

  alias LiveStory.Repo
  alias LiveStory.Stories.Topic

  def change do
    # Using Elixir schemas just to be really quick
    # Fix it if broken, use SQL queries
    topic = Repo.get_by(Topic, slug: "random")
    execute "UPDATE stories_posts SET topic_id=#{topic.id}"
  end
end
