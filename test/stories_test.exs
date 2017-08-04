defmodule Citybuilder.StoriesTest do
  use Citybuilder.DataCase
  #doctest Citybuilder.Stories

  alias Citybuilder.Auths
  alias Citybuilder.Stories
  alias Citybuilder.Stories.Post

  @create_attrs %{"body" => "some body", "title" => "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{"body" => nil, "title" => nil}
  @user_attrs %{"username" => "name", "password" => "123456", "password_confirmation" => "123456"}

  def fixture(:post, attrs \\ @create_attrs) do
    {:ok, user} = Auths.create_user(@user_attrs)
    {:ok, post} = Stories.create_post(attrs, user)
    post |> Repo.preload(:user)
  end

  test "list_posts/1 returns all posts" do
    post = fixture(:post)
    assert Stories.list_posts() == [post]
  end

  test "get_post! returns the post with given id" do
    post = fixture(:post)
    assert Stories.get_post!(post.id) |> Repo.preload([:user]) ==
      post |> Repo.preload(:original_post)
  end

  test "create_post/2 with valid data creates a post" do
    {:ok, user} = Auths.create_user(@user_attrs)
    assert {:ok, %Post{} = post} = Stories.create_post(@create_attrs, user)
    assert post.body == "some body"
    assert post.title == "some title"
    assert post.path == "#{post.id}"
  end

  test "create_forked_post/2" do
    post = fixture(:post)
    {:ok, user} = Auths.create_user(Map.put(@user_attrs, "username", "new"))
    forked_post = Stories.create_forked_post(%Post{title: post.title, body: post.body, id: post.id}, user)
    assert forked_post
    assert forked_post.title == post.title
    assert forked_post.body == post.body
    assert forked_post.id != post.id
    assert forked_post.original_post_id == post.id
    assert forked_post.path == Enum.join([post.id, forked_post.id], ".")
  end

  test "create_post/1 with invalid data returns error changeset" do
    {:ok, user} = Auths.create_user(@user_attrs)
    assert {:error, %Ecto.Changeset{}} = Stories.create_post(@invalid_attrs, user)
  end

  test "update_post/2 with valid data updates the post" do
    post = fixture(:post)
    assert {:ok, post} = Stories.update_post(post, @update_attrs)
    assert %Post{} = post
    assert post.body == "some updated body"
    assert post.title == "some updated title"
  end

  test "update_post/2 with invalid data returns error changeset" do
    post = fixture(:post)
    assert {:error, %Ecto.Changeset{}} = Stories.update_post(post, @invalid_attrs)
    assert post |> Repo.preload(:original_post) ==
      Stories.get_post!(post.id) |> Repo.preload(:user)
  end

  test "delete_post/1 deletes the post" do
    post = fixture(:post)
    assert {:ok, %Post{}} = Stories.delete_post(post)
    assert_raise Ecto.NoResultsError, fn -> Stories.get_post!(post.id) end
  end

  test "change_post/1 returns a post changeset" do
    post = fixture(:post)
    assert %Ecto.Changeset{} = Stories.change_post(post)
  end
end
