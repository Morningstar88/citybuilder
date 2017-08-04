defmodule Citybuilder.Auths.GuardianSerializer do
  @moduledoc """
  This module will serialize users for Guardian to include in its JWTs.
  """

  @behaviour Guardian.Serializer

  alias Citybuilder.Repo
  alias Citybuilder.Auths.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end