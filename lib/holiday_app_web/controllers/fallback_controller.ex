defmodule HolidayAppWeb.FallbackController do
  use HolidayAppWeb, :controller

  def call(conn, {:error, :bad_request}) do
    put_status_and_render(conn, :bad_request, "400.html")
  end

  def call(conn, {:error, :forbidden}) do
    put_status_and_render(conn, :forbidden, "403.html")
  end

  def call(conn, {:error, :unauthorized}) do
    call(conn, {:error, :forbidden})
  end

  def call(conn, {:error, :not_found}) do
    put_status_and_render(conn, :not_found, "404.html")
  end

  defp put_status_and_render(conn, status, template) do
    conn
    |> put_status(status)
    |> put_layout(false)
    |> render(HolidayAppWeb.ErrorView, template)
  end
end
