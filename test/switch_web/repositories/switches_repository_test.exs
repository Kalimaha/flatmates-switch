defmodule SwitchWeb.SwitchesRepositoryTest do
  use Switch.DataCase
  import Switch.Factory

  alias Switch.Repo
  alias SwitchWeb.{Switch, SwitchesRepository}

  test "save new content in the DB" do
    feature_toggle = insert(:feature_toggle)
    SwitchesRepository.save(switch: params_for(:switch, feature_toggle_id: feature_toggle.id))

    assert length(Repo.all(Switch)) == 1
  end

  test "assigns an ID to the record" do
    feature_toggle = insert(:feature_toggle)

    {:ok, switch_record} =
      SwitchesRepository.save(switch: params_for(:switch, feature_toggle_id: feature_toggle.id))

    refute switch_record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert length(SwitchesRepository.list()) == 0
  end

  test "returns all the available records in the DB" do
    feature_toggle = insert(:feature_toggle)
    SwitchesRepository.save(switch: params_for(:switch, feature_toggle_id: feature_toggle.id))

    assert length(SwitchesRepository.list()) == 1
  end

  test "updates an existing record in the DB" do
    feature_toggle = insert(:feature_toggle)

    {:ok, switch} =
      SwitchesRepository.save(switch: params_for(:switch, feature_toggle_id: feature_toggle.id))

    SwitchesRepository.update(id: switch.id, new_params: %{:value => false})

    assert SwitchesRepository.get(id: switch.id).value == false
  end

  test "deletes an existing record in the DB" do
    feature_toggle = insert(:feature_toggle)

    {:ok, switch} =
      SwitchesRepository.save(switch: params_for(:switch, feature_toggle_id: feature_toggle.id))

    SwitchesRepository.delete(id: switch.id)

    assert length(SwitchesRepository.list()) == 0
  end

  test "fetches related toggle" do
    feature_toggle = insert(:feature_toggle)
    switch = insert(:switch, feature_toggle_id: feature_toggle.id)

    switch_feature_toggle = SwitchesRepository.get(id: switch.id).feature_toggle

    assert switch_feature_toggle.env == feature_toggle.env
    assert switch_feature_toggle.external_id == feature_toggle.external_id
    assert switch_feature_toggle.label == feature_toggle.label
    assert switch_feature_toggle.active == feature_toggle.active
    assert switch_feature_toggle.type == feature_toggle.type
  end
end
