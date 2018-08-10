defmodule HolidayApp.Users.UserPolicy do
  @behaviour Bodyguard.Policy

  alias HolidayApp.Users.User

  def authorize(action, user, params)

  def authorize(:index, _, _), do: :ok
  def authorize(:show, _, _), do: :ok

  def authorize(:create, %User{role: role}, _) when role in ["admin", "manager"], do: :ok
  def authorize(:update, %User{role: role}, _) when role in ["admin", "manager"], do: :ok

  def authorize(:update, %User{id: id}, %{user: %User{id: other_id}})
    when id == other_id, do: :ok

  def authorize(_, _, _), do: :error
end
