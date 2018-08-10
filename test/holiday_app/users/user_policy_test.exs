defmodule HolidayApp.Users.UserPolicyTest do
  use HolidayApp.DataCase

  import Bodyguard, only: [permit?: 3, permit?: 4]

  alias HolidayApp.Users.UserPolicy

  defp test_permit_all_except_delete(user, other_user) do
    assert permit?(UserPolicy, :create, user)

    assert permit?(UserPolicy, :index, user)

    assert permit?(UserPolicy, :show, user, user: other_user)

    assert permit?(UserPolicy, :update, user, user: user)
    assert permit?(UserPolicy, :update, user, user: other_user)

    refute permit?(UserPolicy, :delete, user, user: user)
    refute permit?(UserPolicy, :delete, user, user: other_user)
  end

  test "permits admins and managers all actions except :delete" do
    admin = insert(:user, %{role: "admin"})
    manager = insert(:user, %{role: "manager"})
    other_user = insert(:user)

    test_permit_all_except_delete(admin, other_user)
    test_permit_all_except_delete(manager, other_user)
  end

  test "denies user all actions except :index and :show and :update himself" do
    user = insert(:user)
    other_user = insert(:user)

    refute permit?(UserPolicy, :create, user)

    assert permit?(UserPolicy, :index, user)

    assert permit?(UserPolicy, :show, user, user: user)
    assert permit?(UserPolicy, :show, user, user: other_user)

    assert permit?(UserPolicy, :update, user, user: user)
    refute permit?(UserPolicy, :update, user, user: other_user)

    refute permit?(UserPolicy, :delete, user, user: user)
    refute permit?(UserPolicy, :delete, user, user: other_user)
  end
end
