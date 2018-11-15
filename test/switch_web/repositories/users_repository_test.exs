defmodule SwitchWeb.UsersRepositoryTest do
  use Switch.DataCase

  alias Switch.Repo
  alias SwitchWeb.{User, UsersRepository}

  @user %{:external_id => "spam", :source => "flatmates"}

  test "save new content in the DB" do
    UsersRepository.save(@user)

    assert length(Repo.all(User)) == 1
  end

  test "assigns an ID to the record" do
    {:ok, record} = UsersRepository.save(@user)

    refute record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert length(UsersRepository.list()) == 0
  end

  test "returns all the available records in the DB" do
    UsersRepository.save(@user)

    assert length(UsersRepository.list()) == 1
  end

  test "updates an existing record in the DB" do
    {:ok, record} = UsersRepository.save(@user)
    UsersRepository.update(record.id, %{:source => "rea"})

    assert UsersRepository.get(record.id).source == "rea"
  end

  test "deletes an existing record in the DB" do
    {:ok, record} = UsersRepository.save(@user)
    UsersRepository.delete(record.id)

    assert length(UsersRepository.list()) == 0
  end
end
