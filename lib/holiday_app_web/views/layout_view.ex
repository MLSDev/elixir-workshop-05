defmodule HolidayAppWeb.LayoutView do
  use HolidayAppWeb, :view

  def logged_in?(conn), do: conn.assigns[:current_user]
end
