defmodule LiveStory.Repo.Migrations.AddPublishedToStoriesPosts do
  use Ecto.Migration

  def change do
    alter table(:stories_posts) do
      add :published, :boolean, null: false, default: true
    end
  end
end
