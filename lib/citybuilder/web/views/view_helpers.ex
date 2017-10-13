defmodule Citybuilder.Web.ViewHelpers do
  def dom_id(%{__struct__: struct, id: id}) do
    prefix = struct
    |> Atom.to_string
    |> String.split(".")
    |> List.last
    |> Macro.underscore
    Enum.join([prefix, id], "_")
  end
end
