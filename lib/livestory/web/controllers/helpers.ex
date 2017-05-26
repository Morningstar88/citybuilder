defmodule LiveStory.Web.Controller.Helpers do
  def format_datetime(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> Timex.format!("{ANSIC}")
  end
end
