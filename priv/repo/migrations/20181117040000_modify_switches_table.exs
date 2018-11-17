defmodule Switch.Repo.Migrations.ModifySwitchesTable do
  use Ecto.Migration

  def change do
    alter table("switches") do
      remove :user_id
      add :user_external_id, :string
      add :user_source, :string
      add :feature_toggle_env, :string
    end
  end
end
