defmodule HolidayAppWeb.Plugs.FetchCurrentUser do
  import Plug.Conn

  def init(_opts), do: nil

  def call(conn, _) do
    cond do
      user = HolidayAppWeb.Guardian.Plug.current_resource(conn) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end
end
