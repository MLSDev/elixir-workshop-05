defmodule HolidayAppWeb.UserController do
  use HolidayAppWeb, :controller

  alias HolidayApp.Users
  alias HolidayApp.Users.UserPolicy

  action_fallback HolidayAppWeb.FallbackController

  plug HolidayAppWeb.Plugs.Authorize,
    policy: UserPolicy,
    params_fun: &(__MODULE__.fetch_params/2)

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def fetch_params(_conn, %{"id" => id}) do
    [user: Users.get_user!(id)]
  end
  def fetch_params(_, _), do: []
end
