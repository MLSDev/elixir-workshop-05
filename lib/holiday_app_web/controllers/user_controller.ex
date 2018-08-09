defmodule HolidayAppWeb.UserController do
  use HolidayAppWeb, :controller

  alias HolidayApp.Users

  action_fallback HolidayAppWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end
end
