defmodule HolidayApp.Users.RoleTest do
  use HolidayApp.DataCase, async: true

  alias HolidayApp.Users.Role

  setup do
    employee = insert(:user, %{role: "employee"})
    manager = insert(:user, %{role: "manager"})
    admin = insert(:user, %{role: "admin"})
    {:ok, %{employee: employee, manager: manager, admin: admin}}
  end

  describe "roles/0" do
    test "returns list of roles" do
      assert ["employee", "manager", "admin"] == Role.roles()
    end
  end

  describe "role?(user, role)" do
    test "returns true if user has a role", %{employee: employee, manager: manager, admin: admin} do
      assert Role.role?(employee, "employee")
      assert Role.role?(manager, "manager")
      assert Role.role?(admin, "admin")
    end

    test "returns false if user does not have a role", %{
      employee: employee,
      manager: manager,
      admin: admin
    } do
      refute Role.role?(employee, "admin")
      refute Role.role?(manager, "employee")
      refute Role.role?(admin, "manager")
      refute Role.role?(admin, "non-existing-role")
    end

    test "accepts atoms", %{employee: employee, manager: manager, admin: admin} do
      assert Role.role?(employee, :employee)
      assert Role.role?(manager, :manager)
      assert Role.role?(admin, :admin)
      refute Role.role?(admin, :manager)
      refute Role.role?(admin, :non_existing_role)
    end
  end
end
