defmodule HolidayApp.Holidays.HolidayPolicyTest do
  use HolidayApp.DataCase

  import Bodyguard, only: [permit?: 3, permit?: 4]

  alias HolidayApp.Holidays.HolidayPolicy

  setup do
    employee = insert(:user, %{role: "employee"})
    manager = insert(:user, %{role: "manager"})
    admin = insert(:user, %{role: "admin"})
    holiday = insert(:holiday)
    {:ok, %{employee: employee, manager: manager, admin: admin, holiday: holiday}}
  end

  describe "create" do
    test "permits admin and manager", %{admin: admin, manager: manager} do
      assert permit?(HolidayPolicy, :create, admin)
      assert permit?(HolidayPolicy, :create, manager)
    end

    test "denies employee", %{employee: employee} do
      refute permit?(HolidayPolicy, :create, employee)
    end
  end

  describe "index" do
    test "permits all", %{employee: employee, admin: admin, manager: manager} do
      assert permit?(HolidayPolicy, :index, admin)
      assert permit?(HolidayPolicy, :index, employee)
      assert permit?(HolidayPolicy, :index, manager)
    end
  end

  describe "show" do
    test "permits all", %{employee: employee, admin: admin, manager: manager, holiday: holiday} do
      assert permit?(HolidayPolicy, :show, admin, holiday: holiday)
      assert permit?(HolidayPolicy, :show, employee, holiday: holiday)
      assert permit?(HolidayPolicy, :show, manager, holiday: holiday)
    end
  end

  describe "update" do
    test "permits admin and manager", %{admin: admin, manager: manager, holiday: holiday} do
      assert permit?(HolidayPolicy, :update, admin, holiday: holiday)
      assert permit?(HolidayPolicy, :update, manager, holiday: holiday)
    end

    test "denies employee", %{employee: employee, holiday: holiday} do
      refute permit?(HolidayPolicy, :update, employee, holiday: holiday)
    end
  end

  describe "delete" do
    test "permits admin", %{admin: admin, holiday: holiday} do
      assert permit?(HolidayPolicy, :delete, admin, holiday: holiday)
    end

    test "denies employee and manager", %{employee: employee,manager: manager, holiday: holiday} do
      refute permit?(HolidayPolicy, :delete, employee, holiday: holiday)
      refute permit?(HolidayPolicy, :delete, manager, holiday: holiday)
    end
  end
end
