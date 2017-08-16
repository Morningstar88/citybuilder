defmodule Citybuilder.Repo.Migrations.AddProjectLocationField do
  use Ecto.Migration

  def change do
  alter table(:stories_posts) do
    add :project_location, :string

  end
end
end
