defmodule Citybuilder.Repo.Migrations.AllowTopicToBeNull do
  use Ecto.Migration

  def change do
    alter table(:stories_posts) do
      modify :topic_id, :integer, null: true
    end
  end
end
