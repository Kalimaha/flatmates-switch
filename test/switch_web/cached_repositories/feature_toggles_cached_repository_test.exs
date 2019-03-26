defmodule SwitchWeb.FeatureTogglesCachedRepositoryTest do
  use ExUnit.Case, async: true
  use Switch.DataCase

  import Switch.Factory
  import Mock

  alias Switch.FeatureTogglesCache
  alias SwitchWeb.FeatureTogglesCachedRepository

  setup do
    {:ok, feature_toggle: insert(:feature_toggle)}
  end

  test "when feature_toggle is cached, it's fetched from the cache by external id and env", %{
    feature_toggle: feature_toggle
  } do
    with_mock FeatureTogglesCache, lookup: fn _ -> feature_toggle end do
      assert FeatureTogglesCachedRepository.get(
               external_id: feature_toggle.external_id,
               env: feature_toggle.env
             ) == feature_toggle
    end
  end

  test "when feature_toggle is cached, it's fetched from the cache by id", %{
    feature_toggle: feature_toggle
  } do
    with_mock FeatureTogglesCache, lookup: fn _ -> feature_toggle end do
      assert FeatureTogglesCachedRepository.get(id: feature_toggle.id) == feature_toggle
    end
  end

  test "when feature_toggle is NOT cached, it's fetched from the DB by external id and env", %{
    feature_toggle: feature_toggle
  } do
    with_mock FeatureTogglesCache, lookup: fn _ -> nil end do
      assert FeatureTogglesCachedRepository.get(
               external_id: feature_toggle.external_id,
               env: feature_toggle.env
             ).label == feature_toggle.label
    end
  end

  test "when feature_toggle is NOT cached, it's fetched from the DB by id", %{
    feature_toggle: feature_toggle
  } do
    with_mock FeatureTogglesCache, lookup: fn _ -> nil end do
      assert FeatureTogglesCachedRepository.get(id: feature_toggle.id).label ==
               feature_toggle.label
    end
  end

  @tag :skip
  test "when feature_toggle is NOT cached, it's stored in the cache by external id and env", %{
    feature_toggle: feature_toggle
  } do
    with_mocks([
      {FeatureTogglesCache, [], [lookup: fn _key -> nil end]},
      {FeatureTogglesCache, [], [insert: fn _key, _value -> nil end]}
    ]) do
      FeatureTogglesCachedRepository.get(
        external_id: feature_toggle.external_id,
        env: feature_toggle.env
      )

      assert_called(FeatureTogglesCache.lookup(:spam_dev))
      assert_called(FeatureTogglesCache.insert(:spam_dev, :_))
    end
  end

  @tag :skip
  test "when feature_toggle is NOT cached, it's stored in the cache by id", %{
    feature_toggle: feature_toggle
  } do
    with_mocks([
      {FeatureTogglesCache, [], [lookup: fn _key -> nil end]},
      {FeatureTogglesCache, [], [insert: fn _key, _value -> nil end]}
    ]) do
      FeatureTogglesCachedRepository.get(id: feature_toggle.id)

      assert_called(FeatureTogglesCache.lookup(:spam_dev))
      assert_called(FeatureTogglesCache.insert(:spam_dev, :_))
    end
  end
end
