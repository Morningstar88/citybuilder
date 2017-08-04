defmodule Citybuilder.Repo.Migrations.CreateCitybuilder.Stories.Post do
  use Ecto.Migration

  def change do
    create table(:stories_posts) do
      add :title, :string
      add :body, :text

      timestamps()
    end

  end
end
