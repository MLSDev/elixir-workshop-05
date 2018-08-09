defmodule HolidayApp.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :photo_url, :string, size: 2048
      add :hosted_domain, :string
    end
  end
end
