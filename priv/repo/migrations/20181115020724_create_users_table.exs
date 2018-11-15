defmodule Switch.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :external_id, :string
      add :source,      :string
      timestamps()
    end
  end
end
