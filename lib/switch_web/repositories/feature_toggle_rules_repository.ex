defmodule SwitchWeb.FeatureToggleRulesRepository do
  alias Switch.Repo
  alias SwitchWeb.FeatureToggleRule

  def get(id) do
    Repo.get(FeatureToggleRule, id)
  end

  def save(feature_toggle_rule) do
    FeatureToggleRule.changeset(%FeatureToggleRule{}, feature_toggle_rule)
    |> Repo.insert()
  end
end
