defmodule Switch.Repo.Migrations.UpdateSwitchesTable do
  use Ecto.Migration

  def change do
    alter table("switches") do
      add :feature_toggle_id, references(:feature_toggles)
      remove :feature_toggle_env
      remove :feature_toggle_name
    end
  end
end
