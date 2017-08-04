defmodule Citybuilder.Repo.Migrations.RenameCommentsGuestNameToUserName do
  use Ecto.Migration

  def change do
    rename table(:stories_comments), :guest_name, to: :user_name
  end
end
