defmodule SwitchWeb.SwitchesServiceTest do
  use Switch.DataCase
  use ExUnit.Parameterized

  import Switch.Factory

  alias Switch.{FeatureTogglesCache, SwitchesCache}
  alias SwitchWeb.{SwitchesService, SwitchesRepository, FeatureTogglesRepository}

  setup do
    SwitchesCache.delete_all()
    FeatureTogglesCache.delete_all()
    {:ok, user: insert(:user)}
  end

  test_with_params "switch is active based on switch and feature toggle values",
                   %{user: user},
                   fn feature_toggle_value, switch_value, expected ->
                     feature_toggle = insert(:feature_toggle, active: feature_toggle_value)

                     SwitchesRepository.save(
                       switch:
                         params_for(:switch,
                           value: switch_value,
                           user_id: user.external_id,
                           user_source: user.source,
                           feature_toggle_id: feature_toggle.id
                         )
                     )

                     {:ok, switch} =
                       SwitchesService.get_or_create(
                         user_external_id: user.external_id,
                         user_source: user.source,
                         feature_toggle_name: feature_toggle.external_id,
                         feature_toggle_env: feature_toggle.env
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

  test_with_params "fails to create a switch without a user for 'attributes_based' or 'attributes_based_godsend' feature toggles",
                   fn type, expected ->
                     feature_toggle = insert(:feature_toggle, active: true, type: type)

                     {:error, message} =
                       SwitchesService.get_or_create(
                         feature_toggle_name: feature_toggle.external_id,
                         feature_toggle_env: feature_toggle.env
                       )

                     assert message == expected
                   end do
    [
      attributes_based:
        {"attributes_based", "A user is required for 'attributes_based' feature toggles."},
      attributes_based_godsend:
        {"attributes_based_godsend",
         "A user is required for 'attributes_based_godsend' feature toggles."}
    ]
  end

  test "creates a new switch based on a 'simple' feature toggle with the value set to false" do
    feature_toggle = insert(:feature_toggle, active: true)

    {:ok, switch} =
      SwitchesService.get_or_create(
        feature_toggle_name: feature_toggle.external_id,
        feature_toggle_env: feature_toggle.env
      )

    assert switch.value == true
  end

  test "creates a new switch based on a 'simple' feature toggle with the value set to true" do
    feature_toggle = insert(:feature_toggle, active: false)

    {:ok, switch} =
      SwitchesService.get_or_create(
        feature_toggle_name: feature_toggle.external_id,
        feature_toggle_env: feature_toggle.env
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
        user_external_id: user.external_id,
        user_source: user.source,
        feature_toggle_name: feature_toggle.external_id,
        feature_toggle_env: feature_toggle.env
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
        user_external_id: user.external_id,
        user_source: user.source,
        feature_toggle_name: feature_toggle.external_id,
        feature_toggle_env: feature_toggle.env
      )

    assert switch.value == true
  end
end
