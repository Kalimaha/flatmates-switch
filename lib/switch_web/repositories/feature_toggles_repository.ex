defmodule SwitchWeb.FeatureTogglesRepository do
  alias Switch.Repo
  alias SwitchWeb.{FeatureToggle, FeatureToggleRule}

  def save(feature_toggle) do
    FeatureToggle.changeset(%FeatureToggle{}, feature_toggle)
    |> Repo.insert()
  end

  def list do
    Repo.all(FeatureToggle)
    |> Repo.preload(:feature_toggle_rules)
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
    feature_toggle = get(feature_toggle_id)

    unless feature_toggle == nil do
      feature_toggle
      |> Ecto.build_assoc(:feature_toggle_rules, feature_toggle_rule_params)
      |> Repo.insert()
    else
      {:error, "Feature toggle with ID #{feature_toggle_id} not found."}
    end
  end

  def update_rule(feature_toggle_id, feature_toggle_rule_id, feature_toggle_rule_params) do
    feature_toggle = get(feature_toggle_id)

    unless feature_toggle == nil do
      feature_toggle.feature_toggle_rules
      |> Enum.find(&(&1.id == feature_toggle_rule_id))
      |> FeatureToggleRule.changeset(feature_toggle_rule_params)
      |> Repo.update()
    else
      {:error, "Feature toggle with ID #{feature_toggle_id} not found."}
    end
  end

  def remove_rule(feature_toggle_id, feature_toggle_rule_id) do
    feature_toggle = get(feature_toggle_id)

    unless feature_toggle == nil do
      feature_toggle_rule = Repo.get(FeatureToggleRule, feature_toggle_rule_id)

      unless feature_toggle_rule == nil do
        feature_toggle_rule
        |> Repo.delete()
      else
        {:error, "Feature toggle rule with ID #{feature_toggle_rule_id} not found."}
      end
    else
      {:error, "Feature toggle with ID #{feature_toggle_id} not found."}
    end
  end
end
