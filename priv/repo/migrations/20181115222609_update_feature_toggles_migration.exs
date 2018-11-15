defmodule Switch.Repo.Migrations.UpdateFeatureTogglesMigration do
  use Ecto.Migration

  def change do
    alter table("feature_toggles") do
      add :label, :string
      remove :status
      add :active, :boolean
    end
  end
end
