defmodule Citybuilder.Repo.Migrations.CreateCitybuilder.Addresses.Country do
  use Ecto.Migration

  def change do
    create table(:addresses_countries) do
      add :name, :string
      add :slug, :string

      timestamps()
    end

  end
end
