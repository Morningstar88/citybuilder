defmodule LiveStory.Repo.Migrations.CreateLiveStory.Stories.Topic do
  use Ecto.Migration

  def change do
    create table(:stories_topics) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :position, :integer, null: false

      timestamps()
    end

    create index(:stories_topics, :name, unique: true)
    create index(:stories_topics, :slug, unique: true)
    create index(:stories_topics, :position, unique: true)
  end
end
