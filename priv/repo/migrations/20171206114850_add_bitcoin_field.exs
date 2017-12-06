defmodule Citybuilder.Repo.Migrations.AddBitcoinField do
  use Ecto.Migration

  def change do
  alter table(:stories_posts) do
    add :bitcoin_address, :string

  end
end
end
