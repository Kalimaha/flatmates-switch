defmodule SwitchWeb.FeatureTogglesCachedRepository do
  alias Switch.FeatureTogglesCache
  alias SwitchWeb.FeatureTogglesRepository

  def get(external_id: external_id, env: env) do
    cached_feature_toggle =
      cache_key(external_id, env) |> atomize() |> FeatureTogglesCache.lookup()

    case cached_feature_toggle do
      nil -> cache_and_return(external_id, env)
      _ -> cached_feature_toggle
    end
  end

  defp atomize(id) do
    cond do
      Kernel.is_bitstring(id) -> String.to_atom(id)
      Kernel.is_integer(id) -> String.to_atom(Integer.to_string(id))
    end
  end

  defp cache_key(external_id, env) do
    "#{external_id}_#{env}"
  end

  defp cache_and_return(external_id, env) do
    db_feature_toggle = FeatureTogglesRepository.get(external_id: external_id, env: env)

    case db_feature_toggle do
      nil ->
        nil

      _ ->
        spawn(fn ->
          cache_key(external_id, env) |> FeatureTogglesCache.insert(db_feature_toggle)
        end)

        db_feature_toggle
    end
  end
end
