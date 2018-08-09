defmodule HolidayAppWeb.ViewHelpers do
  use Phoenix.HTML

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
end
