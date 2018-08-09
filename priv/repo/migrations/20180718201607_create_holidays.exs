defmodule HolidayApp.Repo.Migrations.CreateHolidays do
  use Ecto.Migration

  def change do
    create table(:holidays) do
      add :title, :string
      add :date, :date
      add :kind, :string

      timestamps()
    end

  end
end
