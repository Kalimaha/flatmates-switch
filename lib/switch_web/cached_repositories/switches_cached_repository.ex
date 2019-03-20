defmodule SwitchWeb.SwitchesCachedRepository do
  alias Switch.SwitchesCache
  alias SwitchWeb.SwitchesRepository

  def get(id: id) do
    cached_switch = atomize(id) |> SwitchesCache.lookup()

    case cached_switch do
      nil -> cache_and_return(id)
      _ -> cached_switch
    end
  end

  def get(
        user_external_id: user_external_id,
        user_source: user_source,
        feature_toggle_name: feature_toggle_name,
        feature_toggle_env: feature_toggle_env
      ) do
    cached_switch =
      cache_key(user_external_id, user_source, feature_toggle_name, feature_toggle_env)
      |> atomize()
      |> SwitchesCache.lookup()

    case cached_switch do
      nil ->
        cache_and_return(user_external_id, user_source, feature_toggle_name, feature_toggle_env)

      _ ->
        cached_switch
    end
  end

  def get(feature_toggle_name: feature_toggle_name, feature_toggle_env: feature_toggle_env) do
    cached_switch =
      cache_key(feature_toggle_name, feature_toggle_env) |> atomize() |> SwitchesCache.lookup()

    case cached_switch do
      nil -> cache_and_return(feature_toggle_name, feature_toggle_env)
      _ -> cached_switch
    end
  end

  defp cache_key(user_external_id, user_source, feature_toggle_name, feature_toggle_env) do
    "#{user_external_id}_#{user_source}_#{feature_toggle_name}_#{feature_toggle_env}"
  end

  defp cache_key(feature_toggle_name, feature_toggle_env) do
    "#{feature_toggle_name}_#{feature_toggle_env}"
  end

  defp atomize(id) do
    cond do
      Kernel.is_bitstring(id) -> String.to_atom(id)
      Kernel.is_integer(id) -> String.to_atom(Integer.to_string(id))
    end
  end

  defp cache_and_return(id) do
    db_switch = SwitchesRepository.get(id: id)

    case db_switch do
      nil ->
        nil

      _ ->
        spawn(fn -> atomize(db_switch.id) |> SwitchesCache.insert(db_switch) end)
        db_switch
    end
  end

  defp cache_and_return(user_external_id, user_source, feature_toggle_name, feature_toggle_env) do
    db_switch =
      SwitchesRepository.get(
        user_external_id: user_external_id,
        user_source: user_source,
        feature_toggle_name: feature_toggle_name,
        feature_toggle_env: feature_toggle_env
      )

    case db_switch do
      nil ->
        nil

      _ ->
        spawn(fn ->
          cache_key(user_external_id, user_source, feature_toggle_name, feature_toggle_env)
          |> atomize()
          |> SwitchesCache.insert(db_switch)
        end)

        db_switch
    end
  end

  defp cache_and_return(feature_toggle_name, feature_toggle_env) do
    db_switch =
      SwitchesRepository.get(
        feature_toggle_name: feature_toggle_name,
        feature_toggle_env: feature_toggle_env
      )

    case db_switch do
      nil ->
        nil

      _ ->
        spawn(fn ->
          cache_key(feature_toggle_name, feature_toggle_env)
          |> atomize()
          |> SwitchesCache.insert(db_switch)
        end)

        db_switch
    end
  end
end
