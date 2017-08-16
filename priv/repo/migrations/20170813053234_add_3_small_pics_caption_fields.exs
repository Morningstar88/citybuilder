defmodule Citybuilder.Repo.Migrations.Add3SmallPicsCaptionFields do
  use Ecto.Migration

  def change do
    alter table (:stories_posts) do
      add :small_pic_1_caption, :string
      add :small_pic_2_caption, :string
      add :small_pic_3_caption, :string
  end
end
end
