defmodule SwitchWeb.UsersCachedRepositoryTest do
  use ExUnit.Case, async: true
  use Switch.DataCase

  import Switch.Factory
  import Mock

  alias Switch.{Repo, UsersCache}
  alias SwitchWeb.{User, UsersCachedRepository}

  setup do
    {:ok, user: insert(:user)}
  end

  test "when user is cached, it's fetched from the cache by id", %{user: user} do
    with_mock UsersCache, lookup: fn _ -> user end do
      assert UsersCachedRepository.get(user.id) == user
    end
  end

  test "when user is cached, it's fetched from the cache by id and source", %{user: user} do
    with_mock UsersCache, lookup: fn _ -> user end do
      assert UsersCachedRepository.get(user.id, user.source) == user
    end
  end

  test "when user is NOT cached, it's fetched from the DB", %{user: user} do
    with_mock UsersCache, lookup: fn _ -> nil end do
      assert UsersCachedRepository.get(user.id) == user
    end
  end

  test "when user is NOT cached, it's stored in the cache", %{user: user} do
    with_mocks([
      {UsersCache, [], [lookup: fn _key -> nil end]},
      {UsersCache, [], [insert: fn _key, _value -> nil end]}
    ]) do
      UsersCachedRepository.get(user.id)

      assert_called(UsersCache.insert(String.to_atom(Integer.to_string(user.id)), user))
    end
  end

  test "returns an empty array when there are no records in the DB" do
    with_mocks([
      {UsersCache, [], [lookup: fn _key -> nil end]},
      {UsersCache, [], [insert: fn _key, _value -> nil end]}
    ]) do
      UsersCachedRepository.get(123)

      assert length(Repo.all(User)) == 1
    end
  end
end
