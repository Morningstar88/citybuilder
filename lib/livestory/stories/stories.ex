defmodule LiveStory.Stories do
  @moduledoc """
  The boundary for the Stories system.
  """
  import Ecto.{Query, Changeset}, warn: false
  alias LiveStory.Repo

  alias LiveStory.Auths.User
  alias LiveStory.Stories.Post
  alias LiveStory.Stories.Topic
  alias LiveStory.Stories.Upvotes
  alias LiveStory.Stories.UpvotesCounts

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    posts_query() |> Repo.all
  end
  def list_posts(topic_id) do
    from(p in posts_query(),
      where: p.topic_id == ^topic_id
    ) |> Repo.all
  end

  def list_forks(post_id) do
    from(p in posts_query(),
      where: p.original_post_id == ^post_id
    ) |> Repo.all
  end

  defp posts_query do
    from(p in Post,
      join: uc in assoc(p, :upvotes_count),
      where: p.published == true,
      order_by: [desc: uc.count],
      preload: [:user, :upvotes_count]
    )
  end

  def list_topics do
    from(t in Topic,
      order_by: t.position
    ) |> Repo.all
  end

  def list_user_upvotes(%User{id: user_id}, post_ids) do
    from(uv in Upvotes,
      where: uv.user_id == ^user_id,
      where: uv.post_id in ^post_ids,
      select: uv.post_id
    )
    |> Repo.all
    |> Enum.map(fn(upvote_id) -> {upvote_id, true} end)
    |> Map.new
  end
  def list_user_upvotes(nil, _post_ids), do: %{}

  def count_forks([]), do: %{}
  def count_forks(paths) do
    from(p in Post,
      where: p.published == true,
      where: fragment("? ~ ?", p.path, ^paths_query(paths)),
      group_by: fragment("top"),
      select: {fragment("subpath(path, 0, 1) as top"), count(p.id)}
    )
    |> Repo.all
    |> Enum.map(fn({key, count}) -> {key, count - 1} end)
    |> Enum.into(%{})
  end

  @doc """
  Converts paths list to `ltree` query

  ## Example
      iex> LiveStory.Stories.paths_query(~w(123 124))
      "123|124.*"
  """
  def paths_query(paths) do
    paths = paths
    |> Enum.map(&root_path/1)
    |> Enum.uniq
    |> Enum.join("|")
    paths <> ".*"
    #{}"6|7.*"
  end

  def root_path(path) do
    path
    |> String.split(".")
    |> List.first
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    from(p in Post,
      where: p.id == ^id,
      preload: [:topic, :original_post]
    )
    |> Repo.one!
  end

  def get_topic!(slug) do
    Repo.get_by!(Topic, slug: slug)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, user) do
    try do
      Repo.transaction fn ->
        post = %Post{}
        |> post_changeset(Map.merge(attrs, %{"user_id" => user.id}))
        |> Repo.insert!
        %UpvotesCounts{}
        |> upvotes_counts_changeset(%{post_id: post.id})
        |> Repo.insert!
        post
      end
    rescue
      error in Ecto.InvalidChangesetError -> {:error, error.changeset}
    end
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> post_changeset(attrs)
    |> check_original_post(post)
    |> Repo.update
  end

  defp check_original_post(changeset, post) do
    {_, post_body} = fetch_field(changeset, :body)
    if get_change(changeset, :published) && not_changed?(post.original_post, post_body) do
      changeset
      |> add_error(:body, "Same as original post")
    else
      changeset
    end
  end

  defp not_changed?(original_post, post_body) do
    String.equivalent?(original_post.body, post_body)
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    post_changeset(post, attrs)
  end

  def create_forked_post(%Post{} = post, user) do
    create_post(%{
      "topic_id" => post.topic_id,
      "title" => post.title,
      "body" => post.body,
      "published" => false,
      "original_post_id" => post.id
    }, user)
    |> case do
      {:ok, new_post} -> new_post
      {:error, error} -> error
    end
  end

  def upvote(post_id, user_id) do
    try do
      Repo.transaction fn ->
        upvote_changeset(%Upvotes{}, %{"user_id" => user_id, "post_id" => post_id})
        |> Repo.insert!
        from(uc in UpvotesCounts,
          where: uc.post_id == ^post_id,
          update: [inc: [count: 1]]
        ) |> Repo.update_all([])
      end
    rescue
      error in Ecto.InvalidChangesetError -> {:error, error.changeset}
    end
  end

  def delete_upvote(%Post{id: post_id}, user_id) do
    Repo.transaction fn ->
      upvote = Repo.get_by!(Upvotes, post_id: post_id, user_id: user_id)
      Repo.delete!(upvote)
      from(uc in UpvotesCounts,
        where: uc.post_id == ^post_id,
        update: [inc: [count: -1]]
      ) |> Repo.update_all([])
    end
  end

  defp post_changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id, :published, :original_post_id, :topic_id]) #Need to change this to Para1, Para2 at some point.
    |> validate_required([:title, :body, :user_id, :topic_id]) #Need to change this to Para1, Para2 at some point.
  end

  defp upvote_changeset(%Upvotes{} = upvote, attrs) do
    upvote
    |> cast(attrs, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id, name: :stories_upvotes_post_id_user_id_index)
  end

  defp upvotes_counts_changeset(%UpvotesCounts{} = upvotes_counts, attrs) do
    upvotes_counts
    |> cast(attrs, [:post_id])
    |> validate_required([:post_id])
    |> foreign_key_constraint(:post_id)
    |> unique_constraint(:post_id)
  end
end
