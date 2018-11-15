defmodule Switch.Repo.Migrations.CreateSwitchesTable do
  use Ecto.Migration

  def change do
    create table(:switches) do
      add :user_id,             references(:users),           null: false
      add :feature_toggle_name, :string
      add :value,               :boolean
      timestamps()
    end
  end
end
