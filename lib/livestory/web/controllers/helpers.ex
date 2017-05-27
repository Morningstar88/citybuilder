defmodule LiveStory.Web.Controller.Helpers do
  def format_datetime(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.format!("{ANSIC}")
  end

  def can_modify_comment?(user, comment) do
    user.id == comment.user_id
  end
end
