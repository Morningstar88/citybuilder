defmodule LiveStory.Session do
  
  alias LiveStory.Repo
  alias LiveStory.Auths.User

  def authenticate(username, password) do
    user =
      case username do
        nil -> nil
        "" -> nil
        username -> Repo.get_by(User, username: username)
      end

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, nil}
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end
end
