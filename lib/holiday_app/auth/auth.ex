defmodule HolidayApp.Auth do
  alias HolidayApp.Users

  require Logger

  @doc """
  Performs user authentication depending on `auth` provider and credentials.
  ## Return values
      * {:ok, %User{} = user}
      * {:error, reason}
  """
  def authenticate(auth)

  def authenticate(%Ueberauth.Auth{provider: :identity} = auth) do
    email = auth.info.email
    password = auth.credentials.other.password

    Users.find_by_email_and_password(email, password)
  end

  def authenticate(%Ueberauth.Auth{} = auth) do
    parse_auth(auth) |> Users.create_or_update_user()
  end

  defp parse_auth(%Ueberauth.Auth{} = auth) do
    %{
      provider: to_string(auth.provider),
      uid: auth.uid,
      email: auth.info.email,
      name: parse_name(auth),
      photo_url: parse_photo_url(auth),
      hosted_domain: parse_hosted_domain(auth)
    }
  end

   defp parse_name(auth) do
     if auth.info.name do
       auth.info.name
     else
       name = [auth.info.first_name, auth.info.last_name]
       |> Enum.filter(&(&1 != nil and &1 != ""))

       cond do
         length(name) == 0 -> auth.info.nickname
         true -> Enum.join(name, " ")
       end
     end
   end

  defp parse_photo_url(%Ueberauth.Auth{info: %{image: image}}), do: image
  defp parse_photo_url(%Ueberauth.Auth{info: %{urls: %{avatar_url: image}}}), do: image
  # default case if nothing matches
  defp parse_photo_url(%Ueberauth.Auth{} = auth) do
    Logger.warn auth.provider <> " needs to find a photo URL!"
    Logger.debug(Poison.encode!(auth))
    nil
  end

  defp parse_hosted_domain(%Ueberauth.Auth{extra: %{raw_info: %{user: user}}}) do
    user["hd"]
  end
  defp parse_hosted_domain(_), do: nil
end
