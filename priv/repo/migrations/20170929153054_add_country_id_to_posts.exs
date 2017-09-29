defmodule Citybuilder.Repo.Migrations.AddCountryIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:stories_posts) do
      add :country_id, references(:addresses_countries)
    end

    create index(:stories_posts, :country_id)
  end
end
