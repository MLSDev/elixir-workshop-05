defmodule HolidayAppWeb.Plugs.EnsureAdmin do
  import Plug.Conn

  alias HolidayAppWeb.FallbackController

  def init(_opts), do: nil

  def call(conn, _) do
    current_user = conn.assigns.current_user
    unless current_user.is_admin do
      conn
      |> FallbackController.call({:error, :forbidden})
      |> halt()
    else
      conn
    end
  end
end
