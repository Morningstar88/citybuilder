defmodule LiveStory.StoriesTest do
  use LiveStory.DataCase

  alias LiveStory.Stories
  alias LiveStory.Stories.Post

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  def fixture(:post, attrs \\ @create_attrs) do
    {:ok, post} = Stories.create_post(attrs)
    post
  end

  test "list_posts/1 returns all posts" do
    post = fixture(:post)
    assert Stories.list_posts() == [post]
  end

  test "get_post! returns the post with given id" do
    post = fixture(:post)
    assert Stories.get_post!(post.id) == post
  end

  test "create_post/1 with valid data creates a post" do
    assert {:ok, %Post{} = post} = Stories.create_post(@create_attrs)
    assert post.body == "some body"
    assert post.title == "some title"
  end

  test "create_post/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Stories.create_post(@invalid_attrs)
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
    assert post == Stories.get_post!(post.id)
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
