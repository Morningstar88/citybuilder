defmodule Citybuilder.Stories.Topic do
  use Ecto.Schema

  schema "stories_topics" do
    field :name, :string
    field :slug, :string
    field :position, :integer

    timestamps()
  end
end
