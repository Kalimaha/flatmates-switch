defmodule SwitchWeb.CacheHelperTest do
  use Switch.DataCase

  import Mock
  import Switch.Factory

  alias Switch.{UsersCache, SwitchesCache, FeatureTogglesCache}
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

  test "clear switch cache by id" do
    with_mock SwitchesCache, delete: fn _ -> nil end do
      switch = insert(:switch)
      CacheHelper.clear_cache(switch: switch)

      assert_called(SwitchesCache.delete(CacheHelper.atomize(switch.id)))
    end
  end

  test "clear switch cache by feature toggle name and feature toggle env" do
    with_mock SwitchesCache, delete: fn _ -> nil end do
      feature_toggle = insert(:feature_toggle)
      switch = insert(:switch, feature_toggle: feature_toggle, user_id: nil, user_source: nil)
      Switch.Repo.preload(switch, :feature_toggle)

      CacheHelper.clear_cache(switch: switch)

      assert_called(
        SwitchesCache.delete(
          CacheHelper.atomize("#{switch.feature_toggle.external_id}_#{switch.feature_toggle.env}")
        )
      )
    end
  end

  test "clear switch cache by user external id, user source, feature toggle name and feature toggle env" do
    with_mock SwitchesCache, delete: fn _ -> nil end do
      feature_toggle = insert(:feature_toggle)

      switch =
        insert(:switch, feature_toggle: feature_toggle, user_id: "eggs", user_source: "bacon")

      Switch.Repo.preload(switch, :feature_toggle)

      CacheHelper.clear_cache(switch: switch)

      assert_called(
        SwitchesCache.delete(
          CacheHelper.atomize(
            "eggs_bacon_#{switch.feature_toggle.external_id}_#{switch.feature_toggle.env}"
          )
        )
      )
    end
  end

  test "clear feature toggle cache by id" do
    with_mock FeatureTogglesCache, delete: fn _ -> nil end do
      feature_toggle = insert(:feature_toggle)
      CacheHelper.clear_cache(feature_toggle: feature_toggle)

      assert_called(FeatureTogglesCache.delete(CacheHelper.atomize(feature_toggle.id)))
    end
  end

  test "clear feature toggle cache by external id and env" do
    with_mock FeatureTogglesCache, delete: fn _ -> nil end do
      feature_toggle = insert(:feature_toggle)
      CacheHelper.clear_cache(feature_toggle: feature_toggle)

      assert_called(
        FeatureTogglesCache.delete(
          CacheHelper.atomize("#{feature_toggle.external_id}_#{feature_toggle.env}")
        )
      )
    end
  end
end
