defmodule SwitchWeb.FeatureToggleRulesRepositoryTest do
  use Switch.DataCase

  alias Switch.Repo
  alias SwitchWeb.{FeatureTogglesRepository, FeatureToggleRulesRepository, FeatureToggleRule}

  @feature_toggle %{
    :external_id => "spam",
    :status => "eggs",
    :env => "bacon",
    :type => "simple"
  }

  test "gets a single rule" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)
    {:ok, rule} = FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    assert FeatureToggleRulesRepository.get(rule.id).threshold == 0.42
  end

  test "save new content in the DB" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    FeatureToggleRulesRepository.save(%{
      :feature_toggle_id => feature_toggle.id,
      :type => "simple"
    })

    assert length(Repo.all(FeatureToggleRule)) == 1
  end
end
