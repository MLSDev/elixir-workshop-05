defmodule HolidayAppWeb.ViewHelpers do
  use Phoenix.HTML

  alias HolidayApp.Users.UserPolicy

  def current_user(conn) do
    conn.assigns[:current_user]
  end
  
  def logged_in?(conn) do
    current_user(conn) != nil
  end

  def admin?(conn) do
    user = current_user(conn)
    user && user.is_admin
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
end
