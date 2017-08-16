defmodule Citybuilder.Repo.Migrations.AddMissingFieldsToRepo do
  use Ecto.Migration
# added to dsn2 branch to fix cloned Repo.
  def change do
  alter table (:stories_posts) do
 
  add :done_so_far_one, :string
    add :done_so_far_two, :string
    add :done_so_far_three, :string
    add :done_so_far_one_title, :string
    add :done_so_far_two_title, :string
    add :done_so_far_three_title, :string
    add :name_of_gallery, :string
    add :future_plans_title, :string
    add :project_pic, :string
    add :text_pic_one, :string
    add :text_pic_two, :string
    add :text_pic_three, :string
    add :small_pic_1_caption, :string
    add :small_pic_2_caption, :string
    add :small_pic_3_caption, :string
    add :project_location, :string

  end
end
end
