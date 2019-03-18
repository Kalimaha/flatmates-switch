defmodule SwitchWeb.SwitchesServiceTest do
  use Switch.DataCase
  # use ExUnit.Case, async: true

  import Switch.Factory

  alias SwitchWeb.{SwitchesService, SwitchesRepository, FeatureTogglesRepository}

  setup do
    {:ok, user: insert(:user)}
  end

  test "toggle is OFF, switch is OFF", %{user: user} do
    feature_toggle = insert(:feature_toggle, active: false)
    SwitchesRepository.save(switch: params_for(:switch, value: false, user_id: user.external_id, user_source: user.source, feature_toggle_id: feature_toggle.id))

    {:ok, switch} = SwitchesService.get_or_create( user_external_id: user.external_id, user_source: user.source, feature_toggle_name: feature_toggle.external_id, feature_toggle_env: feature_toggle.env)

    assert switch.value == false
  end

  test "toggle is OFF, switch is ON", %{user: user} do
    feature_toggle = insert(:feature_toggle, active: false)
    SwitchesRepository.save(switch: params_for(:switch, value: true, user_id: user.external_id, user_source: user.source, feature_toggle_id: feature_toggle.id))

    {:ok, switch} = SwitchesService.get_or_create( user_external_id: user.external_id, user_source: user.source, feature_toggle_name: feature_toggle.external_id, feature_toggle_env: feature_toggle.env)

    assert switch.value == false
  end

  test "toggle is ON, switch is ON", %{user: user} do
    feature_toggle = insert(:feature_toggle, active: true)
    SwitchesRepository.save(switch: params_for(:switch, value: true, user_id: user.external_id, user_source: user.source, feature_toggle_id: feature_toggle.id))

    {:ok, switch} = SwitchesService.get_or_create( user_external_id: user.external_id, user_source: user.source, feature_toggle_name: feature_toggle.external_id, feature_toggle_env: feature_toggle.env)

    assert switch.value == true
  end

  test "toggle is ON, switch is OFF", %{user: user} do
    feature_toggle = insert(:feature_toggle, active: true)
    SwitchesRepository.save(switch: params_for(:switch, value: false, user_id: user.external_id, user_source: user.source, feature_toggle_id: feature_toggle.id))

    {:ok, switch} = SwitchesService.get_or_create( user_external_id: user.external_id, user_source: user.source, feature_toggle_name: feature_toggle.external_id, feature_toggle_env: feature_toggle.env)

    assert switch.value == false
  end

  test "fails to create a switch without a user for 'attributes_based' feature toggle" do
    feature_toggle = insert(:feature_toggle, active: true, type: "attributes_based")

    {:error, message} = SwitchesService.get_or_create(feature_toggle_name: feature_toggle.external_id, feature_toggle_env: feature_toggle.env)

    assert message == "A user is required for 'attributes_based' feature toggles."
  end

  test "fails to create a switch without a user for 'attributes_based_godsend' feature toggle" do
    feature_toggle = insert(:feature_toggle, active: true, type: "attributes_based_godsend")

    {:error, message} = SwitchesService.get_or_create(feature_toggle_name: feature_toggle.external_id, feature_toggle_env: feature_toggle.env)

    assert message == "A user is required for 'attributes_based_godsend' feature toggles."
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
