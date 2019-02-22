defmodule Switch.Repo.Migrations.AddFeatureTogglesIndex do
  use Ecto.Migration

  def up do
    create unique_index(:feature_toggles, [:external_id, :env], name: :index_external_id_env)
  end

  def down do
    drop index(:feature_toggles, [:external_id, :env], name: :index_external_id_env)
  end
end
