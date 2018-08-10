defmodule HolidayAppWeb.HolidayControllerTest do
  use HolidayAppWeb.ConnCase

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
      get(conn, holiday_path(conn, :new)),
      post(conn, holiday_path(conn, :create, %{})),
      get(conn, holiday_path(conn, :index)),
      get(conn, holiday_path(conn, :show, "123")),
      get(conn, holiday_path(conn, :edit, "123")),
      put(conn, holiday_path(conn, :update, "123", %{})),
      delete(conn, holiday_path(conn, :delete, "123"))
    ], fn conn ->
      assert redirected_to(conn) == auth_path(conn, :new)
      assert conn.halted
    end)
  end

  @tag login: :user
  test "requires admin", %{conn: conn} do
    holiday = insert(:holiday)
    Enum.each([
      get(conn, holiday_path(conn, :new)),
      post(conn, holiday_path(conn, :create, %{})),
      get(conn, holiday_path(conn, :edit, holiday.id)),
      put(conn, holiday_path(conn, :update, holiday.id, %{"kind" => "workday"})),
      delete(conn, holiday_path(conn, :delete, holiday.id))
    ], fn conn ->
      assert html_response(conn, :forbidden) =~ "Forbidden"
    end)
  end

  describe "index" do
    @tag login: :user
    test "lists all holidays", %{conn: conn} do
      conn = get conn, holiday_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Holidays"
    end

    @tag login: :user
    test "accepts date range", %{conn: conn} do
      insert(:holiday, %{date: ~D[2018-01-01], title: "New Year"})
      insert(:holiday, %{date: ~D[2018-02-14], title: "St. Valentine"})
      conn = get conn, holiday_path(conn, :index, start_date: "2018-01-01", end_date: "2018-01-31")
      response = html_response(conn, 200)
      assert response =~ "New Year"
      refute response =~ "St. Valentine"
    end
  end

  
  describe "show" do
    @tag login: :user
    test "shows a holiday", %{conn: conn} do
      %{id: id} = insert(:holiday)
      conn = get conn, holiday_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Holiday"
    end
  end

  describe "new" do
    @tag login: :admin
    test "renders form", %{conn: conn} do
      conn = get conn, holiday_path(conn, :new)
      assert html_response(conn, 200) =~ "New Holiday"
    end
  end

  describe "create" do
    @tag login: :admin
    test "redirects to show when data is valid", %{conn: conn} do
      params = string_params_for(:holiday)
      conn = post conn, holiday_path(conn, :create), holiday: params

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == holiday_path(conn, :show, id)

      conn = get conn, holiday_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Holiday"
    end

    @tag login: :admin
    test "renders errors when data is invalid", %{conn: conn} do
      params = %{"kind" => ""}
      conn = post conn, holiday_path(conn, :create), holiday: params
      assert html_response(conn, 200) =~ "New Holiday"
    end
  end

  describe "edit" do
    @tag login: :admin
    test "renders form for editing chosen holiday", %{conn: conn} do
      holiday = insert(:holiday)
      conn = get conn, holiday_path(conn, :edit, holiday)
      assert html_response(conn, 200) =~ "Edit Holiday"
    end
  end

  describe "update" do
    setup %{conn: conn} do
      holiday = insert(:holiday)
      {:ok, conn: conn, holiday: holiday}
    end

    @tag login: :admin
    test "redirects when data is valid", %{conn: conn, holiday: holiday} do
      params = %{"kind" => "workday"}
      conn = put conn, holiday_path(conn, :update, holiday), holiday: params
      assert redirected_to(conn) == holiday_path(conn, :show, holiday)

      conn = get conn, holiday_path(conn, :show, holiday)
      assert html_response(conn, 200) =~ "workday"
    end

    @tag login: :admin
    test "renders errors when data is invalid", %{conn: conn, holiday: holiday} do
      params = %{"kind" => ""}
      conn = put conn, holiday_path(conn, :update, holiday), holiday: params
      assert html_response(conn, 200) =~ "Edit Holiday"
    end
  end

  describe "delete" do
    @tag login: :admin
    test "deletes chosen holiday", %{conn: conn} do
      holiday = insert(:holiday)
      conn = delete conn, holiday_path(conn, :delete, holiday)
      assert redirected_to(conn) == holiday_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, holiday_path(conn, :show, holiday)
      end
    end
  end
end
