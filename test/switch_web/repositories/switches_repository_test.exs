defmodule SwitchWeb.SwitchesRepositoryTest do
  use Switch.DataCase

  alias Switch.Repo
  alias SwitchWeb.{Switch, SwitchesRepository, UsersRepository}

  @user %{external_id: "spam", source: "flatmates"}

  test "save new content in the DB" do
    {:ok, record} = UsersRepository.save(@user)
    switch = %{:user_id => record.id, :feature_toggle_name => "spam", :value => true}
    SwitchesRepository.save(switch)

    assert length(Repo.all(Switch)) == 1
  end

  test "assigns an ID to the record" do
    {:ok, record} = UsersRepository.save(@user)
    switch = %{:user_id => record.id, :feature_toggle_name => "spam", :value => true}
    {:ok, switch_record} = SwitchesRepository.save(switch)

    refute switch_record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert length(SwitchesRepository.list()) == 0
  end

  test "returns all the available records in the DB" do
    {:ok, record} = UsersRepository.save(@user)
    switch = %{:user_id => record.id, :feature_toggle_name => "spam", :value => true}
    SwitchesRepository.save(switch)

    assert length(SwitchesRepository.list()) == 1
  end

  test "updates an existing record in the DB" do
    {:ok, record} = UsersRepository.save(@user)
    switch = %{:user_id => record.id, :feature_toggle_name => "spam", :value => true}
    {:ok, saved_switch} = SwitchesRepository.save(switch)
    SwitchesRepository.update(saved_switch.id, %{:value => false})

    assert SwitchesRepository.get(saved_switch.id).value == false
  end

  test "deletes an existing record in the DB" do
    {:ok, record} = UsersRepository.save(@user)
    switch = %{:user_id => record.id, :feature_toggle_name => "spam", :value => true}
    {:ok, saved_switch} = SwitchesRepository.save(switch)
    SwitchesRepository.delete(saved_switch.id)

    assert length(SwitchesRepository.list()) == 0
  end
end
