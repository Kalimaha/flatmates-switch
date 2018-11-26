defmodule SwitchWeb.SwitchesServiceTest do
  use Switch.DataCase

  import Switch.Factory

  alias SwitchWeb.SwitchesService

  test "creates a new switch based on a simple feature toggle with the value set to false" do
    user = insert(:user)
    feature_toggle = insert(:feature_toggle, active: true)

    {:ok, switch} =
      SwitchesService.get_or_create(
        user.external_id,
        user.source,
        feature_toggle.external_id,
        feature_toggle.env
      )

    assert switch.value == true
  end

  test "creates a new switch based on a simple feature toggle with the value set to true" do
    user = insert(:user)
    feature_toggle = insert(:feature_toggle, active: false)

    {:ok, switch} =
      SwitchesService.get_or_create(
        user.external_id,
        user.source,
        feature_toggle.external_id,
        feature_toggle.env
      )

    assert switch.value == false
  end
end
