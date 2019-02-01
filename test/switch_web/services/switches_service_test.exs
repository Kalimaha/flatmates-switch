defmodule SwitchWeb.SwitchesServiceTest do
  use Switch.DataCase
  use ExUnit.Parameterized

  import Switch.Factory

  alias SwitchWeb.{SwitchesService, SwitchesRepository}

  setup do
    {:ok, user: insert(:user)}
  end

  test_with_params "switch is active based on switch and feature toggle values",
                   %{user: user},
                   fn feature_toggle_value, switch_value, expected ->
                     feature_toggle = insert(:feature_toggle, active: feature_toggle_value)

                     SwitchesRepository.save(
                       params_for(:switch,
                         value: switch_value,
                         user_id: user.external_id,
                         user_source: user.source,
                         feature_toggle_id: feature_toggle.id
                       )
                     )

                     {:ok, switch} =
                       SwitchesService.get_or_create(
                         user.external_id,
                         user.source,
                         feature_toggle.external_id,
                         feature_toggle.env
                       )

                     assert switch.value == expected
                   end do
    [
      "toggle is OFF, switch is OFF": {false, false, false},
      "toggle is OFF, switch is ON": {false, true, false},
      "toggle is ON, switch is ON": {true, true, true},
      "toggle is ON, switch is OFF": {true, false, false}
    ]
  end

  test "creates a new switch based on a 'simple' feature toggle with the value set to false", %{
    user: user
  } do
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

  test "creates a new switch based on a 'simple' feature toggle with the value set to true", %{
    user: user
  } do
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

  test "creates a new switch based on a 'godsend' feature toggle with the value set to false", %{
    user: user
  } do
    feature_toggle = insert(:feature_toggle, active: true, type: "godsend")
    insert(:feature_toggle_rule, feature_toggle: feature_toggle, threshold: 0.0)

    {:ok, switch} =
      SwitchesService.get_or_create(
        user.external_id,
        user.source,
        feature_toggle.external_id,
        feature_toggle.env
      )

    assert switch.value == false
  end

  test "creates a new switch based on a 'godsend' feature toggle with the value set to true", %{
    user: user
  } do
    feature_toggle = insert(:feature_toggle, active: true, type: "godsend")
    insert(:feature_toggle_rule, feature_toggle: feature_toggle, threshold: 100.0)

    {:ok, switch} =
      SwitchesService.get_or_create(
        user.external_id,
        user.source,
        feature_toggle.external_id,
        feature_toggle.env
      )

    assert switch.value == true
  end
end
