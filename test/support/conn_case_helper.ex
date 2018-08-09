defmodule HolidayAppWeb.ConnCaseHelper do
  import Plug.Conn
  import Phoenix.ConnTest

  @endpoint HolidayAppWeb.Endpoint

  def build_conn_with_session() do
    build_conn()
    |> bypass_through(HolidayAppWeb.Router, [:browser])
    |> get("/")
  end

  def build_conn_and_login(user) do
    build_conn_with_session()
    |> HolidayAppWeb.Guardian.Plug.sign_in(user)
    |> HolidayAppWeb.Plugs.FetchCurrentUser.call(%{})
    |> send_resp(200, "Flush session")
    |> recycle()
  end
end
