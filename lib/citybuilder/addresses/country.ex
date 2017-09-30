defmodule Citybuilder.Addresses.Country do
  use Ecto.Schema

  @derive {Phoenix.Param, key: :slug}
  schema "addresses_countries" do
    field :name, :string
    field :slug, :string

    timestamps()
  end
end
