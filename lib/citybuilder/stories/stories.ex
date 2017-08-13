defmodule Citybuilder.Stories do
  @moduledoc """
  The boundary for the Stories system.
  """
  use Arc.Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Citybuilder.Repo

  alias Citybuilder.Auths.User
  alias Citybuilder.Stories.Comment
  alias Citybuilder.Stories.CommentUpvotes
  alias Citybuilder.Stories.CommentUpvotesCount
  alias Citybuilder.Stories.Post
  alias Citybuilder.Stories.Topic
  alias Citybuilder.Stories.Upvotes
  alias Citybuilder.Stories.UpvotesCounts

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
      where: p.topic_id == ^topic_id,
      distinct: fragment("subpath(path, 0, 1)")
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

  def list_user_post_upvotes(%User{id: user_id}, post_ids) do
    from(uv in Upvotes,
      where: uv.user_id == ^user_id,
      where: uv.post_id in ^post_ids,
      select: uv.post_id
    )
    |> Repo.all
    |> Enum.map(fn(upvote_id) -> {upvote_id, true} end)
    |> Map.new
  end
  def list_user_post_upvotes(nil, _post_ids), do: %{}

  def list_user_comment_upvotes(%User{id: user_id}, comment_ids) do
    from(cu in CommentUpvotes,
      where: cu.user_id == ^user_id,
      where: cu.comment_id in ^comment_ids,
      select: cu.comment_id
    )
    |> Repo.all
    |> Enum.map(fn(upvote_id) -> {upvote_id, true} end)
    |> Map.new
  end
  def list_user_comment_upvotes(nil, _comment_ids), do: %{}

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
      iex> Citybuilder.Stories.paths_query(~w(123 124))
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
      preload: [:topic, :original_post, :upvotes_count]
    )
    |> Repo.one!
  end

  def get_comment!(id) do
    from(c in Comment,
      where: c.id == ^id,
      preload: :post
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
      |> add_error(:body, " (°◇°) Same as original post! You must make some changes to this post before submitting it. ", class: "same-as-orig-post")
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
  def delete_post(%Post{} = post, %User{} = user) do
    post
    |> post_changeset()
    |> put_change(:modified_by_id, user.id)
    |> put_change(removal_key(user), true)
    |> Repo.update
  end

  def restore_post(%Post{} = post, %User{} = user) do
    post
    |> updated_recently?()
    |> do_restore(post, user)
  end

  defp do_restore(true, %Post{} = post, %User{} = user) do
    post = post
    |> post_changeset()
    |> put_change(:modified_by_id, user.id)
    |> put_change(removal_key(user), false)
    |> Repo.update!
    {:ok, post}
  end
  defp do_restore(false, _post, _user) do
    {:error, "Post can't be restored"}
  end

  def delete_comment(%Comment{} = comment, %User{} = user) do
    comment
    |> comment_changeset()
    |> put_change(:modified_by_id, user.id)
    |> put_change(removal_key(user), true)
    |> Repo.update
  end

  def restore_comment(%Comment{} = comment, %User{} = user) do
    comment
    |> updated_recently?()
    |> do_restore(comment, user)
  end

  defp do_restore(true, %Comment{} = comment, %User{} = user) do
    comment = comment
    |> comment_changeset()
    |> put_change(:modified_by_id, user.id)
    |> put_change(removal_key(user), false)
    |> Repo.update!
    |> preload_comment_upvotes_count
    {:ok, comment}
  end
  defp do_restore(false, _comment, _user) do
    {:error, "Comment can't be restored"}
  end

  defp updated_recently?(%{updated_at: updated_at}) do
    Timex.before?(Timex.now, Timex.shift(updated_at, seconds: 10))
  end

  defp removal_key(%User{admin: true}), do: :removed_by_moderator
  defp removal_key(%User{moderator: true}), do: :removed_by_moderator
  defp removal_key(%User{}), do: :removed_by_owner

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

  def comment_upvote(comment_id, user_id) do
    try do
      Repo.transaction fn ->
        %CommentUpvotes{}
        |> comment_upvote_changeset(%{"user_id" => user_id, "comment_id" => comment_id})
        |> Repo.insert!
        from(uc in CommentUpvotesCount,
          where: uc.comment_id == ^comment_id,
          update: [inc: [count: 1]]
        ) |> Repo.update_all([])
      end
    rescue
      error in Ecto.InvalidChangesetError -> {:error, error.changeset}
    end
  end

  def post_comments(post_id) do
    from(c in Comment,
      where: c.post_id == ^post_id,
      order_by: [asc: :id],
      preload: [:upvotes_count]
    ) |> Repo.all
  end

  def create_comment(params, post_id, user_id) do
    try do
      Repo.transaction fn ->
        comment = %Comment{}
        |> comment_changeset(params)
        |> put_change(:user_id, user_id)
        |> put_change(:post_id, post_id)
        |> Repo.insert!
        %CommentUpvotesCount{}
        |> comments_upvotes_counts_changeset(%{comment_id: comment.id})
        |> Repo.insert!
        comment
        |> Repo.preload(:upvotes_count)
      end
    rescue
      error in Ecto.InvalidChangesetError -> {:error, error.changeset}
    end
  end

  def update_comment(params, comment, user) do
    comment
    |> comment_changeset(params)
    |> put_change(:modified_by_id, user.id)
    |> Repo.update
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

  def delete_comment_upvote(%Comment{id: comment_id}, user_id) do
    Repo.transaction fn ->
      upvote = Repo.get_by!(CommentUpvotes, comment_id: comment_id, user_id: user_id)
      Repo.delete!(upvote)
      from(uc in CommentUpvotesCount,
        where: uc.comment_id == ^comment_id,
        update: [inc: [count: -1]]
      ) |> Repo.update_all([])
    end
  end

  def preload_comment_upvotes_count(comment) do
    Repo.preload(comment, :upvotes_count)
  end

  def new_post_comment(post, comment_attrs \\ %{}) do
    post
    |> Ecto.build_assoc(:comments)
    |> comment_changeset(comment_attrs)
  end

  defp post_changeset(%Post{} = post, attrs \\ %{}) do
    post
    |> cast(attrs, [:title, :body, :user_id, :published, :original_post_id, :topic_id, :plan, :done_so_far_one, :done_so_far_two, :done_so_far_three, :done_so_far_one_title, :done_so_far_two_title, :done_so_far_three_title, :name_of_gallery, :future_plans_title, :small_pic_1_caption, :small_pic_2_caption, :small_pic_3_caption, :project_location]) #Need to change this to Para1, Para2 at some point.
    |> cast_attachments(attrs, [:project_pic, :text_pic_one, :text_pic_two, :text_pic_three])
    |> validate_required([:title, :body, :user_id, :topic_id, :plan, :done_so_far_one, :done_so_far_two, :done_so_far_three,  :done_so_far_one_title, :done_so_far_two_title, :done_so_far_three_title, :project_pic, :name_of_gallery, :future_plans_title, :small_pic_1_caption, :small_pic_2_caption, :small_pic_3_caption, :project_location]) #Need to change this to Para1, Para2 at some point.
  end

  def comment_changeset(%Comment{} = comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:user_name, :body])
    |> validate_required([:user_name, :body])
    |> validate_length(:user_name, max: 25) # same in auths username
    |> validate_length(:body, max: 1100)
  end

  defp upvote_changeset(%Upvotes{} = upvote, attrs) do
    upvote
    |> cast(attrs, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id, name: :stories_upvotes_post_id_user_id_index)
  end

  defp comment_upvote_changeset(%CommentUpvotes{} = upvote, attrs) do
    upvote
    |> cast(attrs, [:comment_id, :user_id])
    |> validate_required([:comment_id, :user_id])
    |> foreign_key_constraint(:comment_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id, name: :stories_comments_upvotes_comment_id_user_id_index)
  end

  defp upvotes_counts_changeset(%UpvotesCounts{} = upvotes_counts, attrs) do
    upvotes_counts
    |> cast(attrs, [:post_id])
    |> validate_required([:post_id])
    |> foreign_key_constraint(:post_id)
    |> unique_constraint(:post_id)
  end

  defp comments_upvotes_counts_changeset(%CommentUpvotesCount{} = upvotes_counts, attrs) do
    upvotes_counts
    |> cast(attrs, [:comment_id])
    |> validate_required([:comment_id])
    |> foreign_key_constraint(:comment_id)
    |> unique_constraint(:comment_id)
  end
end
