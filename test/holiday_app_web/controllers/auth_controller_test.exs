defmodule HolidayAppWeb.AuthControllerTest do
  use HolidayAppWeb.ConnCase

  alias HolidayAppWeb.AuthController

  setup do
    conn = build_conn_with_session()
    user = insert_user_with_password("dummyPassword")

    {:ok, conn: conn, user: user}
  end

  describe "new" do
    test "renders form", %{conn: conn} do
      conn = get conn, auth_path(conn, :new)
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "callback" do
    test "logs user in", %{conn: conn, user: user} do
      conn = post conn, auth_path(conn, :callback, %{
        "email": user.email, "password": "dummyPassword"})
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~  "You have logged in"
    end

    test "denies on wrong password and renders login form again", %{conn: conn, user: user} do
      conn = post conn, auth_path(conn, :callback, %{
        "email": user.email, "password": "wrong"})
      assert redirected_to(conn) == auth_path(conn, :new)
      assert get_flash(conn, :error) =~ "Authentication failed"
    end
  end

  describe "logout" do
    test "logs user out", %{user: user} do
      conn = build_conn_and_login(user)
      conn = delete conn, auth_path(conn, :logout)
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "You have logged out"
    end
  end

  describe "auth_error/3" do
    test "clears session, redirects to login page and puts message to flash" do
      conn =
        build_conn_with_session()
        |> put_session(:my_key, "my value")

      conn = AuthController.auth_error(conn, {:error, "Error message"}, [])

      refute get_session(conn, :my_key)
      assert redirected_to(conn) == auth_path(conn, :new)
      assert get_flash(conn, :error) == "Error message"
    end
  end
end
