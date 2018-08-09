defmodule HolidayAppWeb.UserControllerTest do
  use HolidayAppWeb.ConnCase

  alias HolidayApp.Users.User

  setup %{conn: conn} = config do
    unless config[:no_login] do
      user = insert(:user, %{email: "mail@server.com"})
      conn = build_conn_and_login(user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag no_login: true
  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, user_path(conn, :index)),
      get(conn, user_path(conn, :show, "123")),
    ], fn conn ->
      assert redirected_to(conn) == auth_path(conn, :new)
      assert conn.halted
    end)
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "show" do
    test "renders a user", %{conn: conn} do
      %User{id: id} = insert(:user)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end
  end
end
