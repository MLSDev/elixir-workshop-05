defmodule HolidayAppWeb.HolidayController do
  use HolidayAppWeb, :controller

  alias HolidayApp.Holidays
  alias HolidayApp.Holidays.Holiday

  action_fallback HolidayAppWeb.FallbackController

  def index(conn, params) do
    start_date = params["start_date"]
    end_date = params["end_date"]
    {:ok, holidays, start_date, end_date} = Holidays.list_holidays(start_date, end_date)
    render(conn, "index.html", holidays: holidays, start_date: start_date, end_date: end_date)
  end

  def new(conn, _params) do
    changeset = Holidays.change_holiday(%Holiday{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"holiday" => holiday_params}) do
    case Holidays.create_holiday(holiday_params) do
      {:ok, holiday} ->
        conn
        |> put_flash(:info, "Holiday created successfully.")
        |> redirect(to: holiday_path(conn, :show, holiday))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    holiday = Holidays.get_holiday!(id)
    render(conn, "show.html", holiday: holiday)
  end

  def edit(conn, %{"id" => id}) do
    holiday = Holidays.get_holiday!(id)
    changeset = Holidays.change_holiday(holiday)
    render(conn, "edit.html", holiday: holiday, changeset: changeset)
  end

  def update(conn, %{"id" => id, "holiday" => holiday_params}) do
    holiday = Holidays.get_holiday!(id)

    case Holidays.update_holiday(holiday, holiday_params) do
      {:ok, holiday} ->
        conn
        |> put_flash(:info, "Holiday updated successfully.")
        |> redirect(to: holiday_path(conn, :show, holiday))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", holiday: holiday, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    holiday = Holidays.get_holiday!(id)
    {:ok, _holiday} = Holidays.delete_holiday(holiday)

    conn
    |> put_flash(:info, "Holiday deleted successfully.")
    |> redirect(to: holiday_path(conn, :index))
  end
end
