defmodule SwitchWeb.CacheHelperTest do
  use Switch.DataCase

  import Mock
  import Switch.Factory

  alias Switch.UsersCache
  alias SwitchWeb.CacheHelper

  test "clear user cache by id" do
    with_mock UsersCache, delete: fn _ -> nil end do
      user = insert(:user)
      CacheHelper.clear_cache(user: user)

      assert_called(UsersCache.delete(CacheHelper.atomize(user.id)))
    end
  end

  test "clear user cache by external_id and source" do
    with_mock UsersCache, delete: fn _ -> nil end do
      user = insert(:user)
      CacheHelper.clear_cache(user: user)

      assert_called(UsersCache.delete(CacheHelper.atomize("#{user.external_id}_#{user.source}")))
    end
  end
end
