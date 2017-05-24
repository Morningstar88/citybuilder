defmodule LiveStory.Repo.Migrations.CreateLiveStory.Stoies.Comment do
  use Ecto.Migration

  def change do
    create table(:stories_comments) do
      add :guest_name, :string
      add :body, :text
      add :user_id, references(:auths_users, on_delete: :nothing)
      add :post_id, references(:stories_posts, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:stories_comments, [:user_id])
    create index(:stories_comments, [:post_id])
  end
end
