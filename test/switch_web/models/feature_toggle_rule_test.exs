defmodule SwitchWeb.FeatureToggleRuleTest do
  use Switch.DataCase

  alias SwitchWeb.FeatureToggleRule

  @valid_attributes %{:feature_toggle_id => 42, :type => "simple"}
  @invalid_attributes %{:feature_toggle_id => nil, :type => "simple"}

  test "validates type" do
    changeset =
      FeatureToggleRule.changeset(%FeatureToggleRule{}, %{
        :feature_toggle_id => 42,
        :type => "pippo"
      })

    assert changeset.errors[:type] == {"is invalid", [validation: :inclusion]}
  end

  test "changeset with valid attributes" do
    assert FeatureToggleRule.changeset(%FeatureToggleRule{}, @valid_attributes).valid?
  end

  test "changeset with invalid attributes" do
    refute FeatureToggleRule.changeset(%FeatureToggleRule{}, @invalid_attributes).valid?
  end

  test "threshold must be less than or equal to 1.0" do
    attributes = %{:feature_toggle_id => 42, :threshold => 3.14, :type => "simple"}
    changeset = FeatureToggleRule.changeset(%FeatureToggleRule{}, attributes)

    refute changeset.valid?
  end

  test "threshold must be greater than or equal to 0.0" do
    attributes = %{:feature_toggle_id => 42, :threshold => -0.42, :type => "simple"}
    changeset = FeatureToggleRule.changeset(%FeatureToggleRule{}, attributes)

    refute changeset.valid?
  end

  test "validate 'godsend' rule type" do
    changeset =
      FeatureToggleRule.changeset(%FeatureToggleRule{}, %{
        :feature_toggle_id => 42,
        :type => "godsend"
      })

    assert changeset.errors[:threshold] == {"can't be blank", [validation: :required]}
  end

  test "validate valid 'godsend' rule type" do
    changeset =
      FeatureToggleRule.changeset(%FeatureToggleRule{}, %{
        :feature_toggle_id => 42,
        :type => "godsend",
        :threshold => 0.42
      })

    assert changeset.valid?
  end

  test "validate 'attributes_based' rule type" do
    changeset =
      FeatureToggleRule.changeset(%FeatureToggleRule{}, %{
        :feature_toggle_id => 42,
        :type => "attributes_based"
      })

    assert changeset.errors[:attribute_name] == {"can't be blank", [validation: :required]}
    assert changeset.errors[:attribute_value] == {"can't be blank", [validation: :required]}
    assert changeset.errors[:attribute_operation] == {"can't be blank", [validation: :required]}
  end

  test "validate valid 'attributes_based' rule type" do
    changeset =
      FeatureToggleRule.changeset(%FeatureToggleRule{}, %{
        :feature_toggle_id => 42,
        :type => "attributes_based",
        :attribute_name => "something",
        :attribute_value => 42,
        :attribute_operation => "something"
      })

    assert changeset.valid?
  end

  test "validate 'godsend_attributes_based' rule type" do
    changeset =
      FeatureToggleRule.changeset(%FeatureToggleRule{}, %{
        :feature_toggle_id => 42,
        :type => "godsend_attributes_based"
      })

    assert changeset.errors[:threshold] == {"can't be blank", [validation: :required]}
    assert changeset.errors[:attribute_name] == {"can't be blank", [validation: :required]}
    assert changeset.errors[:attribute_value] == {"can't be blank", [validation: :required]}
    assert changeset.errors[:attribute_operation] == {"can't be blank", [validation: :required]}
  end

  test "validate valid 'godsend_attributes_based' rule type" do
    changeset =
      FeatureToggleRule.changeset(%FeatureToggleRule{}, %{
        :feature_toggle_id => 42,
        :type => "godsend_attributes_based",
        :threshold => 0.42,
        :attribute_name => "something",
        :attribute_value => 42,
        :attribute_operation => "something"
      })

    assert changeset.valid?
  end
end
