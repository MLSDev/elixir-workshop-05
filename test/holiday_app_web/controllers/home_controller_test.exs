defmodule HolidayAppWeb.HomeControllerTest do
  use HolidayAppWeb.ConnCase

  setup do
    user = insert(:user)
    {:ok, user: user}
  end

  describe "index" do
    test "renders login link for not logged in user" do
      conn = build_conn_with_session()
      conn = get conn, home_path(conn, :index)
      assert html_response(conn, 200) =~ "Login"
    end

    test "renders logout link for logged in user", %{user: user} do
      conn = build_conn_and_login(user)
      conn = get conn, home_path(conn, :index)
      assert html_response(conn, 200) =~ "Logout"
    end
  end
end
