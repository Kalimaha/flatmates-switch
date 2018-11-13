defmodule Switch.Repo.Migrations.AddTypeToFeatureToggles do
  use Ecto.Migration

  def change do
    alter table(:feature_toggles) do
      add :type, :string
    end
  end
end
