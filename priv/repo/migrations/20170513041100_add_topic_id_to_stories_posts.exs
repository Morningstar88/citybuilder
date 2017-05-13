defmodule LiveStory.Repo.Migrations.AddTopicIdToStoriesPosts do
  use Ecto.Migration

  def change do
    alter table(:stories_posts) do
      add :topic_id, references(:stories_topics)
    end

    create index(:stories_posts, :topic_id)
  end
end
