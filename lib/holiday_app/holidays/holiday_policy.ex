defmodule HolidayApp.Holidays.HolidayPolicy do
  @behaviour Bodyguard.Policy

  alias HolidayApp.Users.User

  def authorize(action, user, params)

  def authorize(:index, _, _), do: :ok
  def authorize(:show, _, _), do: :ok  

  def authorize(_, %User{is_admin: true}, _), do: :ok

  def authorize(_, _, _), do: :error
end
