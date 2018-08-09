defmodule HolidayAppWeb.ViewHelpers do
  use Phoenix.HTML

  def logged_in?(conn), do: conn.assigns[:current_user]

  def admin?(conn) do
    current_user = conn.assigns[:current_user]
    current_user && current_user.is_admin
  end
end
