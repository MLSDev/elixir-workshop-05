defmodule HolidayApp.Users do
  @moduledoc """
  The Users context.
  """
  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias HolidayApp.Repo
  alias HolidayApp.Users.{User, Role}

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
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples
      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Creates new User.
  """
  def create_user(%{} = attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a User.
  """
  def update_user(%User{} = user, %{} = attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Attempts to find and update an existing User by `email`. If not found, creates new one.
  Returns `{:ok, %User{}}` or `{:error, reason}`
  """
  def create_or_update_user(%{email: email} = attrs)  do
    if user = Repo.get_by(User, email: email) do
      update_user(user, attrs)
    else
      create_user(attrs)
    end
  end

  @doc """
  Assigns new role to user.
  Returns {:ok, %User{}} or `{:error, reason}`
  """
  def assign_role_to_user(%User{} = user, role) do
    change(user, role: role)
    |> validate_inclusion(:role, Role.roles())
    |> Repo.update()
  end

  @doc """
  Make User an admin.
  """
  def make_admin(%User{} = user) do
    change(user, role: "admin") |> Repo.update()
  end
end
