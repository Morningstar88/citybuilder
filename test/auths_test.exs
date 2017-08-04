defmodule Citybuilder.AuthsTest do
  use Citybuilder.DataCase

  alias Citybuilder.Auths
  alias Citybuilder.Auths.User

  @create_attrs %{email: "some email", name: "some name", password: "some password"}
  @update_attrs %{email: "some updated email", name: "some updated name", password: "some updated password"}
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Auths.create_user(attrs)
    user
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Auths.list_users() == [user]
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Auths.get_user!(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Auths.create_user(@create_attrs)
    assert user.email == "some email"
    assert user.name == "some name"
    assert user.password == "some password"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Auths.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Auths.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.email == "some updated email"
    assert user.name == "some updated name"
    assert user.password == "some updated password"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Auths.update_user(user, @invalid_attrs)
    assert user == Auths.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Auths.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Auths.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Auths.change_user(user)
  end
end
