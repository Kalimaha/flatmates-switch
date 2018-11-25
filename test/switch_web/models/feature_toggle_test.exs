defmodule SwitchWeb.FeatureToggleTest do
  use Switch.DataCase
  import Switch.Factory

  alias SwitchWeb.FeatureToggle

  test "changeset with valid attributes" do
    changeset = FeatureToggle.changeset(%FeatureToggle{}, params_for(:feature_toggle))

    assert changeset.valid?
  end

  test "validates required 'external_id' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :env => "test",
        :active => true,
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
        :active => true,
        :type => "simple"
      })

    refute changeset.valid?
  end

  test "validates required 'type' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :active => true,
        :env => "test"
      })

    refute changeset.valid?
  end

  test "validates inclusion for 'type' parameter" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :active => true,
        :env => "test",
        :type => "unknown_type"
      })

    refute changeset.valid?
  end

  test "validates env" do
    changeset =
      FeatureToggle.changeset(%FeatureToggle{}, %{
        :external_id => "spam_and_eggs",
        :active => true,
        :env => "pippo",
        :type => "unknown_type"
      })

    assert changeset.errors[:env] == {"is invalid", [validation: :inclusion]}
  end

  test "accepts a JSON payload" do
    changeset =
      FeatureToggle.changeset(
        %FeatureToggle{},
        params_for(:feature_toggle, payload: %{:spam => "eggs"})
      )

    assert changeset.valid?
  end
end
