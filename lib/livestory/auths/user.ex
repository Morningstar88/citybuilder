defmodule LiveStory.Auths.User do
  use Ecto.Schema

  schema "auths_users" do
    field :email, :string
    field :name, :string
    field :password, :string

    timestamps()
  end
end
