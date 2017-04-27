defmodule LiveStory.Auths.User do
  use Ecto.Schema

  schema "auths_users" do
    field :username, :string
    field :name, :string
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end
end
