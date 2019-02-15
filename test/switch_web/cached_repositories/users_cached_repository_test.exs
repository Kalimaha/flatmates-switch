defmodule SwitchWeb.UsersCachedRepositoryTest do
  use ExUnit.Case, async: true
  use Switch.DataCase

  import Switch.Factory
  import Mock

  alias Switch.UsersCache
  alias SwitchWeb.UsersCachedRepository

  setup do
    {:ok, user: insert(:user)}
  end

  test "when user is cached, it's fetched from the cache by id", %{user: user} do
    with_mock UsersCache, lookup: fn _ -> user end do
      assert UsersCachedRepository.get(id: user.id) == user
    end
  end

  test "when user is cached, it's fetched from the cache by external id and source", %{user: user} do
    with_mock UsersCache, lookup: fn _ -> user end do
      assert UsersCachedRepository.get(external_id: user.id, user_source: user.source) == user
    end
  end

  test "when user is NOT cached, it's fetched from the DB", %{user: user} do
    with_mock UsersCache, lookup: fn _ -> nil end do
      assert UsersCachedRepository.get(id: user.id) == user
    end
  end

  test "when user is NOT cached, it's stored in the cache", %{user: user} do
    with_mocks([
      {UsersCache, [], [lookup: fn _key -> nil end]},
      {UsersCache, [], [insert: fn _key, _value -> nil end]}
    ]) do
      UsersCachedRepository.get(id: user.id)

      assert_called(UsersCache.insert(String.to_atom(Integer.to_string(user.id)), user))
    end
  end
end
