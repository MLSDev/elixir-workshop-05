defmodule HolidayAppWeb.Plugs.FetchCurrentUserTest do
  use HolidayAppWeb.ConnCase

  alias HolidayAppWeb.Plugs.FetchCurrentUser

  test "already assigned current_user makes the plug pass" do
    user = insert(:user)
    conn =
      build_conn_with_session()
      |> HolidayAppWeb.Guardian.Plug.sign_in(user)
      |> FetchCurrentUser.call(%{})

    assert conn.assigns[:current_user]
    assert user.id == conn.assigns[:current_user].id
  end

  test "not logged in user shall not pass" do
    conn =
      build_conn()
      |> FetchCurrentUser.call(%{})

    refute conn.assigns[:current_user]
  end
end
