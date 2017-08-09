defmodule Citybuilder.Repo.Migrations.AddNameOfGalleryToFields do
  use Ecto.Migration

  def change do
  alter table (:stories_posts) do
    add :name_of_gallery, :string

  end
end
end
