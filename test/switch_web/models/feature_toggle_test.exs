defmodule SwitchWeb.FeatureToggleTest do
  use Switch.DataCase

  alias SwitchWeb.FeatureToggle

  @valid_attributes %{
    :external_id => "spam_and_eggs",
    :env => "test",
    :status => "active"
  }

  test "changeset with valid attributes" do
    changeset = FeatureToggle.changeset(%FeatureToggle{}, @valid_attributes)

    assert changeset.valid?
  end

  test "validates required 'external_id' parameter" do
    changeset = FeatureToggle.changeset(%FeatureToggle{}, %{:env => "test", :status => "active"})

    refute changeset.valid?
  end

  test "validates required 'status' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{:external_id => "spam_and_eggs", :env => "test"})

    refute changeset.valid?
  end

  test "validates required 'env' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :status => "active"
      })

    refute changeset.valid?
  end
end
