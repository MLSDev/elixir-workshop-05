defmodule HolidayApp.Repo.Migrations.AddAuthFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :uid, :string
      add :provider, :string, default: "identity"
    end
    create index(:users, [:uid], unique: true)
    create index(:users, [:provider])
  end
end
