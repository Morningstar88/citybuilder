defmodule LiveStory.Repo.Migrations.AddModeratorAndAdminToAuthUsers do
  use Ecto.Migration

  def change do
    alter table(:auths_users) do
      add :admin, :boolean, null: false, default: false
      add :moderator, :boolean, null: false, default: false
    end
  end
end
