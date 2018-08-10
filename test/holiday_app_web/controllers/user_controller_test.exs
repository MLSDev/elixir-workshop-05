defmodule HolidayAppWeb.UserControllerTest do
  use HolidayAppWeb.ConnCase

  alias HolidayApp.Users.User

  setup %{conn: conn} = config do
    if role = config[:login] do
      user = insert(:user, %{role: to_string(role)})
      conn = build_conn_and_login(user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag login: false
  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, user_path(conn, :index)),
      get(conn, user_path(conn, :show, "123")),
      put(conn, user_path(conn, :update, "123", %{})),
    ], fn conn ->
      assert redirected_to(conn) == auth_path(conn, :new)
      assert conn.halted
    end)
  end

  @tag login: :user
  test "requires admin to update other user", %{conn: conn} do
    other_user = insert(:user)
    Enum.each([
      get(conn, user_path(conn, :edit, other_user)),
      put(conn, user_path(conn, :update, other_user, %{name: "New Name"})),
    ], fn conn ->
      assert html_response(conn, :forbidden) =~ "Forbidden"
    end)
  end

  describe "index" do
    @tag login: :user
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "show" do
    @tag login: :user
    test "renders a user", %{conn: conn} do
      %User{id: id} = insert(:user)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end
  end

  describe "edit" do
    @tag login: :admin
    test "renders form for editing chosen user", %{conn: conn} do
      other_user = insert(:user)
      conn = get conn, user_path(conn, :edit, other_user)
      assert html_response(conn, 200) =~ "Edit User"
    end

    @tag login: :user
    test "renders form for editing oneself", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update" do
    @tag login: :admin
    test "redirects when data is valid", %{conn: conn, user: user} do
      params = %{"name" => "Jane"}
      conn = put conn, user_path(conn, :update, user), user: params
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "Jane"
    end

    @tag login: :admin
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      params = %{"name" => "J"}
      conn = put conn, user_path(conn, :update, user), user: params
      assert html_response(conn, 200) =~ "Edit User"
    end
  end
end
