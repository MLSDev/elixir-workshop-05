defmodule HolidayAppWeb.Plugs.EnsureAdminTest do
  use HolidayAppWeb.ConnCase

  alias HolidayAppWeb.Plugs.EnsureAdmin

  describe "call() performs authorization" do
    test "permits admin" do
      admin = insert(:user, %{role: "admin"})
      conn = build_conn_for_user(admin)

      conn = EnsureAdmin.call(conn, %{})

      refute conn.halted
    end

    test "denies unauthorized user, halts connection" do
      user = insert(:user)
      conn = build_conn_for_user(user)

      conn = EnsureAdmin.call(conn, %{})

      assert conn.halted
      assert conn.status == 403
    end
  end
end
