defmodule HolidayApp.Tasks.MigrateFromIsAdminToRole do
  alias HolidayApp.Users

  def convert_is_admin_to_role do
    Users.list_users()
    |> Enum.each(fn user ->
        if user.is_admin, do: Users.make_admin(user)
      end)
  end
end

HolidayApp.Tasks.MigrateFromIsAdminToRole.convert_is_admin_to_role()
