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
    end
  end
end
