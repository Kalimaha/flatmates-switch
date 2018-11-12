defmodule SwitchWeb.FeatureToggleRepository do
  alias Switch.Repo
  alias SwitchWeb.FeatureToggle

  def save(feature_toggle) do
    FeatureToggle.changeset(%FeatureToggle{}, feature_toggle)
    |> Repo.insert()
  end

  def list do
    Repo.all(FeatureToggle)
  end

  def delete(id) do
    get(id)
    |> Repo.delete()
  end

  def get(id) do
    Repo.get(FeatureToggle, id)
  end

  def update(id, new_params) do
    record = get(id)

    FeatureToggle.changeset(record, new_params)
    |> Repo.update()
  end
end
