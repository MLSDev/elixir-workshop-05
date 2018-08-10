defmodule HolidayApp.Holidays.HolidayPolicyTest do
  use HolidayApp.DataCase

  import Bodyguard, only: [permit?: 3, permit?: 4]

  alias HolidayApp.Holidays.HolidayPolicy

  setup do
    user = insert(:user)
    admin = insert(:user, %{is_admin: true})
    holiday = insert(:holiday)
    {:ok, %{user: user, admin: admin, holiday: holiday}}
  end

  describe "create" do
    test "permits admin", %{admin: admin} do
      assert permit?(HolidayPolicy, :create, admin)
    end

    test "denies user", %{user: user} do
      refute permit?(HolidayPolicy, :create, user)
    end
  end

  describe "index" do
    test "permits all", %{user: user, admin: admin} do
      assert permit?(HolidayPolicy, :index, admin)
      assert permit?(HolidayPolicy, :index, user)
    end
  end

  describe "show" do
    test "permits all", %{user: user, admin: admin, holiday: holiday} do
      assert permit?(HolidayPolicy, :show, admin, holiday)
      assert permit?(HolidayPolicy, :show, user, holiday)
    end
  end

  describe "update" do
    test "permits admin", %{admin: admin, holiday: holiday} do
      assert permit?(HolidayPolicy, :update, admin, holiday)
    end

    test "denies user", %{user: user, holiday: holiday} do
      refute permit?(HolidayPolicy, :update, user, holiday)
    end
  end

  describe "delete" do
    test "permits admin", %{admin: admin, holiday: holiday} do
      assert permit?(HolidayPolicy, :delete, admin, holiday)
    end

    test "denies user", %{user: user, holiday: holiday} do
      refute permit?(HolidayPolicy, :delete, user, holiday)
    end
  end
end
