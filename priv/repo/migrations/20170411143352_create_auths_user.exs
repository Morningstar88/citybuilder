defmodule LiveStory.Repo.Migrations.CreateLiveStory.Auths.User do
  use Ecto.Migration

  def change do
    create table(:auths_users) do
      add :name, :string
      add :email, :string
      add :password, :string

      timestamps()
    end

  end
end
