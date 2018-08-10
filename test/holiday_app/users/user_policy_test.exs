defmodule HolidayApp.Users.UserPolicyTest do
  use HolidayApp.DataCase

  import Bodyguard, only: [permit?: 3, permit?: 4]

  alias HolidayApp.Users.UserPolicy

  test "permits admin all actions except :delete" do
    admin = insert(:user, %{is_admin: true})
    other_user = insert(:user)

    assert permit?(UserPolicy, :create, admin)

    assert permit?(UserPolicy, :index, admin)

    assert permit?(UserPolicy, :show, admin, user: other_user)

    assert permit?(UserPolicy, :update, admin, user: admin)
    assert permit?(UserPolicy, :update, admin, user: other_user)

    refute permit?(UserPolicy, :delete, admin, user: admin)
    refute permit?(UserPolicy, :delete, admin, user: other_user)
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
