defmodule HolidayAppWeb.ViewHelpers do
  use Phoenix.HTML

  alias HolidayApp.Users.{Role, UserPolicy}
  alias HolidayApp.Holidays.HolidayPolicy

  def current_user(conn) do
    conn.assigns[:current_user]
  end
  
  def logged_in?(conn) do
    current_user(conn) != nil
  end

  def admin?(conn) do
    user = current_user(conn)
    user && Role.role?(user, :admin)
  end

  def is_current_user?(conn, user) do
    user == current_user(conn)
  end

  def can_update_user?(conn, user) do
    Bodyguard.permit?(
      UserPolicy,
      :update,
      current_user(conn),
      user: user
    )
  end

  def can_create_holiday?(conn) do
    check_holiday_policy(conn, nil, :create)
  end

  def can_update_holiday?(conn, holiday) do
    check_holiday_policy(conn, holiday, :update)
  end

  def can_delete_holiday?(conn, holiday) do
    check_holiday_policy(conn, holiday, :delete)
  end

  defp check_holiday_policy(conn, holiday, action) do
    Bodyguard.permit?(
      HolidayPolicy,
      action,
      current_user(conn),
      holiday: holiday
    )
  end
end
