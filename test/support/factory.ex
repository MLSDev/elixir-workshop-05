defmodule HolidayApp.Factory do
  use ExMachina.Ecto, repo: HolidayApp.Repo

  alias HolidayApp.Holidays.Holiday
  alias HolidayApp.Users.User

  def holiday_factory do
    %Holiday{
      date: random_date(),
      title: sequence(:title, &"Holiday title #{&1}"),
      kind: "holiday"
    }
  end

  def workday_factory do
    %{holiday_factory() | kind: "workday"}
  end

  defp random_date do
    day = Enum.random(1..28)
    month = Enum.random(1..12)
    year = Enum.random(2009..2099)
    {:ok, date} = Date.new(year, month, day)
    date
  end

  def user_factory do
    %User{
      provider: "identity",
      email: sequence(:email, &"email#{&1}@domain.com"),
      password: "P4$$w0rd",
      password_confirmation: "P4$$w0rd"
    }
  end

  def google_user_factory do
    %User{
      provider: "google",
      email: sequence(:email, &"email-#{&1}@domain.com"),
      uid: sequence(:uid, &"abc-#{&1}")
    }
  end

  def insert_user_with_password(password) do
    build(:user)
    |> encrypt_password(password)
    |> insert()
  end

  defp encrypt_password(user, password) do
    user
    |> User.create_changeset(%{
        provider: "identity",
        password: password,
        password_confirmation: password
      })
    |> Ecto.Changeset.apply_changes()
  end
end
