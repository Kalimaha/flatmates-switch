defmodule Switch.Repo.Migrations.AddTypeToFeatureToggleRule do
  use Ecto.Migration

  def change do
    alter table(:feature_toggle_rules) do
      add :type, :string, null: false, default: "simple"
    end
  end
end
