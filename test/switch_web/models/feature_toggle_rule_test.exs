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

  test "threshold must be less than or equal to 1.0" do
    attributes = %{:feature_toggle_id => 42, :threshold => 3.14}
    changeset = FeatureToggleRule.changeset(%FeatureToggleRule{}, attributes)

    refute changeset.valid?
  end

  test "threshold must be greater than or equal to 0.0" do
    attributes = %{:feature_toggle_id => 42, :threshold => -0.42}
    changeset = FeatureToggleRule.changeset(%FeatureToggleRule{}, attributes)

    refute changeset.valid?
  end
end
