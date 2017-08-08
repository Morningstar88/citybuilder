defmodule Citybuilder.Repo.Migrations.AddNameOfGalleryToFields do
  use Ecto.Migration

  def change do
  alter table (:stories_posts) do
    add :future_plans_title, :string

  end
end
end