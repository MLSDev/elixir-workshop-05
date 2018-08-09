defmodule HolidayAppWeb.HomeController do
  use HolidayAppWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
