defmodule SwitchWeb.FeatureToggleTest do
  use Switch.DataCase

  alias SwitchWeb.FeatureToggle

  @valid_attributes %{
    :external_id => "spam_and_eggs",
    :env => "test",
    :status => "active",
    :type => "simple"
  }

  test "changeset with valid attributes" do
    changeset = FeatureToggle.changeset(%FeatureToggle{}, @valid_attributes)

    assert changeset.valid?
  end

  test "validates required 'external_id' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :env => "test",
        :status => "active",
        :type => "simple"
      })

    refute changeset.valid?
  end

  test "validates required 'status' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :env => "test",
        :type => "simple"
      })

    refute changeset.valid?
  end

  test "validates required 'env' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :status => "active",
        :type => "simple"
      })

    refute changeset.valid?
  end

  test "validates required 'type' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :status => "active",
        :env => "test"
      })

    refute changeset.valid?
  end

  test "validates inclusion for 'type' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :status => "active",
        :env => "test",
        :type => "unknown_type"
      })

    refute changeset.valid?
  end
end
