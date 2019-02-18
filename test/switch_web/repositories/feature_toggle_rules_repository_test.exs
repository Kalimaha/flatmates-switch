defmodule SwitchWeb.FeatureToggleRulesRepositoryTest do
  use Switch.DataCase
  import Switch.Factory

  alias Switch.Repo
  alias SwitchWeb.{FeatureTogglesRepository, FeatureToggleRulesRepository, FeatureToggleRule}

  test "gets a single rule" do
    feature_toggle = insert(:feature_toggle)

    {:ok, rule} =
      FeatureTogglesRepository.add_rule(
        feature_toggle_id: feature_toggle.id,
        feature_toggle_rule_params: params_for(:feature_toggle_rule)
      )

    assert FeatureToggleRulesRepository.get(id: rule.id).type == "simple"
  end

  test "save new content in the DB" do
    feature_toggle = insert(:feature_toggle)
    insert(:feature_toggle_rule, feature_toggle_id: feature_toggle.id)

    assert length(Repo.all(FeatureToggleRule)) == 1
  end
end
