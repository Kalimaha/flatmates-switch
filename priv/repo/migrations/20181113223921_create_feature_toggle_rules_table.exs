defmodule Switch.Repo.Migrations.CreateFeatureToggleRulesTable do
  use Ecto.Migration

  def change do
    create table(:feature_toggle_rules) do
      add :feature_toggle_id,   references(:feature_toggles), null: false
      add :attribute_name,      :string
      add :attribute_value,     :float
      add :attribute_operation, :string
      add :threshold,           :float
      timestamps()
    end
  end
end
