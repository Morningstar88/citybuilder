defmodule Citybuilder.Repo.Migrations.CreateCitybuilder.Auths.User do
  use Ecto.Migration

  def change do
    create table(:auths_users) do
      add :username, :string
      add :name, :string
      add :encrypted_password, :string

      timestamps()
    end
    create unique_index(:auths_users, [:username])
  end
end
