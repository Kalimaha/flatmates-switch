defmodule SwitchWeb.UsersRepositoryTest do
  use Switch.DataCase
  import Switch.Factory

  alias Switch.Repo
  alias SwitchWeb.{User, UsersRepository}

  test "save new content in the DB" do
    UsersRepository.save(user: params_for(:user))

    assert length(Repo.all(User)) == 1
  end

  test "assigns an ID to the record" do
    {:ok, record} = UsersRepository.save(user: params_for(:user))

    refute record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert length(UsersRepository.list()) == 0
  end

  test "returns all the available records in the DB" do
    UsersRepository.save(user: params_for(:user))

    assert length(UsersRepository.list()) == 1
  end

  test "updates an existing record in the DB" do
    {:ok, record} = UsersRepository.save(user: params_for(:user))
    UsersRepository.update(id: record.id, new_params: %{:source => "rea"})

    assert UsersRepository.get(id: record.id).source == "rea"
  end

  test "deletes an existing record in the DB" do
    {:ok, record} = UsersRepository.save(user: params_for(:user))
    UsersRepository.delete(id: record.id)

    assert length(UsersRepository.list()) == 0
  end
end
