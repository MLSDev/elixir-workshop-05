defmodule HolidayAppWeb.AuthController do
  use HolidayAppWeb, :controller

  alias HolidayApp.Auth

  plug Ueberauth

  def new(conn, _params) do
    render(conn, :new)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Auth.authenticate(auth) do
      {:ok, user} ->
        conn
        |> HolidayAppWeb.Guardian.Plug.sign_in(user)
        |> put_flash(:info, "You have logged in!")
        |> redirect(to: "/")
      {:error, _reason} ->
        auth_error(conn, {:unauthorized, "Authentication failed"}, [])
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    auth_error(conn, {:unauthorized, "Authentication failed"}, [])
  end

  def logout(conn, _params) do
    conn
    |> HolidayAppWeb.Guardian.Plug.sign_out()
    |> put_flash(:info, "You have logged out.")
    |> redirect(to: "/")
  end

  def auth_error(conn, {_type, reason}, _opts) do
    conn
    |> clear_session()
    |> put_flash(:error, reason)
    |> redirect(to: auth_path(conn, :new))
  end
end
