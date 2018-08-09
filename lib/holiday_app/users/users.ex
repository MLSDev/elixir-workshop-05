defmodule HolidayApp.Users do
  @moduledoc """
  The Users context.
  """
  import Ecto.Query, warn: false

  alias HolidayApp.Repo
  alias HolidayApp.Users.User

  @doc """
  Lists all users
  """
  def list_users, do: Repo.all(User)

  @doc """
  Finds user by `id`.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Finds user by email/password combination.
  Returns `{:ok, user}` or `{:error, message}`.
  Note that the error message is meant to be used for logging purposes only; it should not be passed on to the end user.
  """
  def find_by_email_and_password(email, password) when is_binary(email) and is_binary(password) do
    User
    |> Repo.get_by(email: email)
    |> verify_password(password)
  end

  def find_by_email_and_password(_, _), do: {:error, "Invalid credentials"}

  defp verify_password(user, password) do
    if user && user.password_hash do
      Comeonin.Argon2.check_pass(user, password)
    else
      {:error, "Invalid credentials"}
    end
  end

  @doc """
  Attempts to find and update an existing User by `email`. If not found, creates new one.
  Returns `{:ok, %User{}}` or `{:error, reason}`
  """
  def create_or_update_user(%{email: email} = attrs)  do
    if user = Repo.get_by(User, email: email) do
      User.changeset(user, attrs) |> Repo.update()
    else
      User.create_changeset(%User{}, attrs) |> Repo.insert()
    end
  end
end
