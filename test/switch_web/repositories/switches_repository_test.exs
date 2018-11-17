defmodule SwitchWeb.SwitchesRepositoryTest do
  use Switch.DataCase
  import Switch.Factory

  alias Switch.Repo
  alias SwitchWeb.{Switch, SwitchesRepository, UsersRepository}

  test "save new content in the DB" do
    SwitchesRepository.save(params_for(:switch))

    assert length(Repo.all(Switch)) == 1
  end

  test "assigns an ID to the record" do
    {:ok, switch_record} = SwitchesRepository.save(params_for(:switch))

    refute switch_record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert length(SwitchesRepository.list()) == 0
  end

  test "returns all the available records in the DB" do
    SwitchesRepository.save(params_for(:switch))

    assert length(SwitchesRepository.list()) == 1
  end

  test "updates an existing record in the DB" do
    {:ok, switch} = SwitchesRepository.save(params_for(:switch))
    SwitchesRepository.update(switch.id, %{:value => false})

    assert SwitchesRepository.get(switch.id).value == false
  end

  test "deletes an existing record in the DB" do
    {:ok, switch} = SwitchesRepository.save(params_for(:switch))
    SwitchesRepository.delete(switch.id)

    assert length(SwitchesRepository.list()) == 0
  end
end
