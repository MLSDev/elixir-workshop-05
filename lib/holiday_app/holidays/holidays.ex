defmodule HolidayApp.Holidays do
  @moduledoc """
  The Holidays context.
  """

  import Ecto.Query, warn: false
  alias HolidayApp.Repo

  alias HolidayApp.Holidays.Holiday

  @doc """
  Returns the list of holidays.

  ## Examples
      iex> list_holidays(start_date, end_date)
      {:ok, [%Holiday{}, ...], start_date, end_date}

      iex> list_holidays()
      {:ok, [%Holiday{}, ...], ~D[2018-01-01], ~D[2018-12-31]}

  """
  def list_holidays(start_date \\ nil, end_date \\ nil) do
    start_date = start_date || beginning_of_year()
    end_date = end_date || end_of_year()

    holidays =
      Holiday
      |> where([h], h.date >= ^start_date and h.date <= ^end_date)
      |> order_by(asc: :date)
      |> Repo.all
    {:ok, holidays, start_date, end_date}
  end

  defp beginning_of_year, do: Timex.today |> Timex.beginning_of_year
  defp end_of_year, do: Timex.today |> Timex.end_of_year

  @doc """
  Gets a single holiday.

  Raises `Ecto.NoResultsError` if the Holiday does not exist.

  ## Examples

      iex> get_holiday!(123)
      %Holiday{}

      iex> get_holiday!(456)
      ** (Ecto.NoResultsError)

  """
  def get_holiday!(id), do: Repo.get!(Holiday, id)

  @doc """
  Creates a holiday.

  ## Examples

      iex> create_holiday(%{field: value})
      {:ok, %Holiday{}}

      iex> create_holiday(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_holiday(attrs \\ %{}) do
    %Holiday{}
    |> Holiday.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a holiday.

  ## Examples

      iex> update_holiday(holiday, %{field: new_value})
      {:ok, %Holiday{}}

      iex> update_holiday(holiday, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_holiday(%Holiday{} = holiday, attrs) do
    holiday
    |> Holiday.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Holiday.

  ## Examples

      iex> delete_holiday(holiday)
      {:ok, %Holiday{}}

      iex> delete_holiday(holiday)
      {:error, %Ecto.Changeset{}}

  """
  def delete_holiday(%Holiday{} = holiday) do
    Repo.delete(holiday)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking holiday changes.

  ## Examples

      iex> change_holiday(holiday)
      %Ecto.Changeset{source: %Holiday{}}

  """
  def change_holiday(%Holiday{} = holiday) do
    Holiday.changeset(holiday, %{})
  end
end
