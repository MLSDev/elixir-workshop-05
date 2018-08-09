defmodule HolidayAppWeb.FallbackController do
  use HolidayAppWeb, :controller

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_layout(false)
    |> render(HolidayAppWeb.ErrorView, "400.html")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_layout(false)
    |> render(HolidayAppWeb.ErrorView, "404.html")
  end
end
