defmodule SwitchWeb.FeatureToggleRepository do
  alias Switch.Repo
  alias SwitchWeb.FeatureToggle

  def save(feature_toggle) do
    FeatureToggle.changeset(%FeatureToggle{}, feature_toggle)
    |> Repo.insert
  end

  def list do
    Repo.all(FeatureToggle)
  end

  def delete(id) do
    Repo.get(FeatureToggle, id)
    |> Repo.delete
  end
end
