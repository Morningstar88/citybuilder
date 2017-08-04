defmodule Citybuilder.Repo.Migrations.AddPlanToPosts do
  use Ecto.Migration

  def change do
     alter table(:stories_posts) do
     add :plan, :string
     add :done_so_far, :string
     add :project_pic, :string
     #timestamps
  end
end
end