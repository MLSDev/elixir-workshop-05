defmodule HolidayApp.Users.Role do
  alias HolidayApp.Users.User

  @roles ["employee", "manager", "admin"]

  def roles do
    @roles
  end

  def role?(user, role)

  def role?(user, role) when is_atom(role) do
    role?(user, to_string(role))
  end

  def role?(%User{role: user_role}, role) when role in @roles, do: user_role == role

  def role?(_, _), do: false
end
