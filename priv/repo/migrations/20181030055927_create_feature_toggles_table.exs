defmodule Switch.Repo.Migrations.CreateFeatureTogglesTable do
  use Ecto.Migration

  def change do
    create table("feature_toggles") do
      add :external_id, :string
      add :env,         :string
      add :status,      :string
      timestamps()
    end
  end
end
