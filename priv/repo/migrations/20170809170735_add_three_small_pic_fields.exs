defmodule Citybuilder.Repo.Migrations.AddThreeSmallPicFields do
  use Ecto.Migration

  def change do
    alter table (:stories_posts) do
      add :text_pic_one, :string
      add :text_pic_two, :string
      add :text_pic_three, :string
  end
end
end
