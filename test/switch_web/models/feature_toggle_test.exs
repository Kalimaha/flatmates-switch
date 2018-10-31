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
end
