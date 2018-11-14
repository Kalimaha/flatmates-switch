defmodule SwitchWeb.FeatureTogglesRepository do
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
    |> Repo.preload(:feature_toggle_rules)
  end

  def update(id, new_params) do
    record = get(id)

    FeatureToggle.changeset(record, new_params)
    |> Repo.update()
  end

  def add_rule(feature_toggle_id, feature_toggle_rule_params) do
    get(feature_toggle_id)
    |> Ecto.build_assoc(:feature_toggle_rules, feature_toggle_rule_params)
    |> Repo.insert()
  end
end
