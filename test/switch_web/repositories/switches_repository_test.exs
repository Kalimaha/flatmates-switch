defmodule SwitchWeb.SwitchesRepositoryTest do
  use Switch.DataCase
  import Switch.Factory

  alias Switch.Repo
  alias SwitchWeb.{Switch, SwitchesRepository, UsersRepository}

  test "save new content in the DB" do
    user = insert(:user)
    switch = params_for(:switch, user_id: user.id)
    SwitchesRepository.save(switch)

    assert length(Repo.all(Switch)) == 1
  end

  test "assigns an ID to the record" do
    user = insert(:user)
    switch = params_for(:switch, user_id: user.id)
    {:ok, switch_record} = SwitchesRepository.save(switch)

    refute switch_record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert length(SwitchesRepository.list()) == 0
  end

  test "returns all the available records in the DB" do
    user = insert(:user)
    switch = params_for(:switch, user_id: user.id)
    SwitchesRepository.save(switch)

    assert length(SwitchesRepository.list()) == 1
  end

  test "updates an existing record in the DB" do
    user = insert(:user)
    switch = params_for(:switch, user_id: user.id)
    {:ok, saved_switch} = SwitchesRepository.save(switch)
    SwitchesRepository.update(saved_switch.id, %{:value => false})

    assert SwitchesRepository.get(saved_switch.id).value == false
  end

  test "deletes an existing record in the DB" do
    user = insert(:user)
    switch = params_for(:switch, user_id: user.id)
    {:ok, saved_switch} = SwitchesRepository.save(switch)
    SwitchesRepository.delete(saved_switch.id)

    assert length(SwitchesRepository.list()) == 0
  end

  test "find switches by user" do
    user = insert(:user)
    switch = insert(:switch, user_id: user.id)
    switches = SwitchesRepository.list(user.id)

    assert Enum.map(switches, &(&1.id)) == [switch.id]
  end
end
