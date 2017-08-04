defmodule Citybuilder.Repo.Migrations.AddUserIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:stories_posts) do
      add :user_id, references(:auths_users), null: false
    end

    create index(:stories_posts, :user_id)
  end
end
