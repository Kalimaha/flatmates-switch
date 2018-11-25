defmodule Switch.Repo.Migrations.AddPayloadToFeatureToggles do
  use Ecto.Migration

  def change do
    alter table("feature_toggles") do
      add :payload, :map, default: "{}"
    end
  end
end
