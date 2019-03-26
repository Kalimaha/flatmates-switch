defmodule SwitchWeb.FeatureTogglesRepository do
  import Ecto.Query

  alias Switch.Repo
  alias SwitchWeb.{FeatureToggle, FeatureToggleRule, FeatureToggleRulesRepository, CacheHelper}

  def save(feature_toggle: feature_toggle) do
    FeatureToggle.changeset(%FeatureToggle{}, feature_toggle)
    |> Repo.insert()
  end

  def list do
    Repo.all(FeatureToggle)
    |> Repo.preload(:feature_toggle_rules)
  end

  def delete(id: id) do
    {:ok, feature_toggle} = get(id: id) |> Repo.delete()

    CacheHelper.clear_cache(feature_toggle: feature_toggle)

    {:ok, feature_toggle}
  end

  def get(id: id) do
    Repo.get(FeatureToggle, id)
    |> Repo.preload(:feature_toggle_rules)
  end

  def get(external_id: external_id, env: env) do
    from(
      f in FeatureToggle,
      where: f.external_id == ^external_id and f.env == ^env
    )
    |> Repo.one()
    |> Repo.preload(:feature_toggle_rules)
  end

  def update(id: id, new_params: new_params) do
    {:ok, feature_toggle} = get(id: id) |> FeatureToggle.changeset(new_params) |> Repo.update()

    CacheHelper.clear_cache(feature_toggle: feature_toggle)

    {:ok, feature_toggle}
  end

  def add_rule(
        feature_toggle_id: feature_toggle_id,
        feature_toggle_rule_params: feature_toggle_rule_params
      ) do
    feature_toggle = get(id: feature_toggle_id)

    unless feature_toggle == nil do
      feature_toggle
      |> Ecto.build_assoc(:feature_toggle_rules, feature_toggle_rule_params)
      |> Repo.insert()
    else
      {:error, "Feature toggle with ID #{feature_toggle_id} not found."}
    end
  end

  def update_rule(
        feature_toggle_id: feature_toggle_id,
        feature_toggle_rule_id: feature_toggle_rule_id,
        feature_toggle_rule_params: feature_toggle_rule_params
      ) do
    feature_toggle = get(id: feature_toggle_id)

    unless feature_toggle == nil do
      feature_toggle_rule = FeatureToggleRulesRepository.get(id: feature_toggle_rule_id)

      unless feature_toggle_rule == nil do
        feature_toggle_rule
        |> FeatureToggleRule.changeset(feature_toggle_rule_params)
        |> Repo.update()
      else
        {:error, "Feature toggle rule with ID #{feature_toggle_rule_id} not found."}
      end
    else
      {:error, "Feature toggle with ID #{feature_toggle_id} not found."}
    end
  end

  def remove_rule(
        feature_toggle_id: feature_toggle_id,
        feature_toggle_rule_id: feature_toggle_rule_id
      ) do
    feature_toggle = get(id: feature_toggle_id)

    unless feature_toggle == nil do
      feature_toggle_rule = FeatureToggleRulesRepository.get(id: feature_toggle_rule_id)

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
