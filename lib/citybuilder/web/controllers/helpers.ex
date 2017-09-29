defmodule Citybuilder.Web.Controller.Helpers do
  import Citybuilder.Web.Router.Helpers

  def format_datetime(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    # format sample: May 26, 2:32pm, 2017
    # formatters: https://github.com/bitwalker/timex/blob/master/lib/format/datetime/formatters/default.ex
    |> Timex.format!("{Mfull} {D}, {h12}:{m}{am}, {YYYY}")
  end

  def can_modify?(nil, _comment), do: false
  def can_modify?(user, comment) do
    user.admin ||
    user.moderator ||
    (user.id == comment.user_id)
  end

  # TODO: re-create this as a macro
  def path_to(:post, %{assigns: %{country: nil}} = conn, :new) do
    post_path(conn, :new)
  end
  def path_to(:post, %{assigns: %{country: country}} = conn, :new) do
    country_post_path(conn, :new, country.slug)
  end
  def path_to(:post, %{assigns: %{country: nil}} = conn, :create) do
    post_path(conn, :create)
  end
  def path_to(:post, %{assigns: %{country: country}} = conn, :create) do
    country_post_path(conn, :create, country.slug)
  end
  def path_to(:post, %{assigns: %{country: nil}} = conn, :show, post) do
    post_path(conn, :show, post)
  end
  def path_to(:post, %{assigns: %{country: country}} = conn, :show, post) do
    country_post_path(conn, :show, country.slug, post)
  end
end
