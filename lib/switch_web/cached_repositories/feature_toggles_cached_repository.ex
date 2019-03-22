defmodule SwitchWeb.FeatureTogglesCachedRepository do
  alias Switch.FeatureTogglesCache
  alias SwitchWeb.{FeatureTogglesRepository, CacheHelper}

  def get(id: id) do
    cached_feature_toggle = id |> CacheHelper.atomize() |> FeatureTogglesCache.lookup()

    case cached_feature_toggle do
      nil -> cache_and_return(id)
      _ -> cached_feature_toggle
    end
  end

  def get(external_id: external_id, env: env) do
    cached_feature_toggle =
      cache_key(external_id, env) |> CacheHelper.atomize() |> FeatureTogglesCache.lookup()

    case cached_feature_toggle do
      nil -> cache_and_return(external_id, env)
      _ -> cached_feature_toggle
    end
  end

  defp cache_key(external_id, env) do
    "#{external_id}_#{env}"
  end

  defp cache_and_return(id) do
    db_feature_toggle = FeatureTogglesRepository.get(id: id)

    case db_feature_toggle do
      nil ->
        nil

      _ ->
        spawn(fn ->
          id |> CacheHelper.atomize() |> FeatureTogglesCache.insert(db_feature_toggle)
        end)

        db_feature_toggle
    end
  end

  defp cache_and_return(external_id, env) do
    db_feature_toggle = FeatureTogglesRepository.get(external_id: external_id, env: env)

    case db_feature_toggle do
      nil ->
        nil

      _ ->
        spawn(fn ->
          cache_key(external_id, env)
          |> CacheHelper.atomize()
          |> FeatureTogglesCache.insert(db_feature_toggle)
        end)

        db_feature_toggle
    end
  end
end
