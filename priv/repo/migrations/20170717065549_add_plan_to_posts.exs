defmodule LiveStory.Repo.Migrations.AddPlanToPosts do
  use Ecto.Migration

  def change do
     alter table(:stories_posts) do
     add :plan, :string

     #timestamps
  end
end
end