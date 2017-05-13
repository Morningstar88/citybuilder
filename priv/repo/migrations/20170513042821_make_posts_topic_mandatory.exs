defmodule LiveStory.Repo.Migrations.MakePostsTopicMandatory do
  use Ecto.Migration

  def change do
    alter table(:stories_posts) do
      modify :topic_id, :integer, null: false
    end
  end
end
