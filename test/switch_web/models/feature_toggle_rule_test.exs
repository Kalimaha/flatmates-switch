defmodule SwitchWeb.FeatureToggleRuleTest do
  use Switch.DataCase

  alias SwitchWeb.FeatureToggleRule

  @valid_attributes %{:feature_toggle_id => 42}
  @invalid_attributes %{:feature_toggle_id => nil}

  test "changeset with valid attributes" do
    assert FeatureToggleRule.changeset(%FeatureToggleRule{}, @valid_attributes).valid?
  end

  test "changeset with invalid attributes" do
    refute FeatureToggleRule.changeset(%FeatureToggleRule{}, @invalid_attributes).valid?
  end
end
