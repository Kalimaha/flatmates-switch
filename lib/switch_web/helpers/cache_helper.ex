defmodule SwitchWeb.CacheHelper do
  alias Switch.{UsersCache, SwitchesCache, FeatureTogglesCache}

  def clear_cache(user: user) do
    case user.id do
      nil -> nil
      _ -> user.id |> atomize() |> UsersCache.delete()
    end

    case {user.external_id, user.source} do
      {nil, nil} -> nil
      {_, _} -> "#{user.external_id}_#{user.source}" |> atomize() |> UsersCache.delete()
    end
  end

  def clear_cache(switch: switch) do
    case switch.id do
      nil -> nil
      _ -> switch.id |> atomize() |> SwitchesCache.delete()
    end

    try do
      case {switch.user_id, switch.user_source, switch.feature_toggle.external_id,
            switch.feature_toggle.env} do
        {_, _, nil, nil} ->
          nil

        {nil, nil, nil, nil} ->
          nil

        {nil, nil, _, _} ->
          "#{switch.feature_toggle.external_id}_#{switch.feature_toggle.env}"
          |> atomize()
          |> SwitchesCache.delete()

        {_, _, _, _} ->
          "#{switch.user_id}_#{switch.user_source}_#{switch.feature_toggle.external_id}_#{
            switch.feature_toggle.env
          }"
          |> atomize()
          |> SwitchesCache.delete()
      end
    rescue
      e in KeyError -> e
    end
  end

  def clear_cache(feature_toggle: feature_toggle) do
    case feature_toggle.id do
      nil -> nil
      _ -> feature_toggle.id |> atomize() |> FeatureTogglesCache.delete()
    end

    case {feature_toggle.external_id, feature_toggle.env} do
      {nil, nil} ->
        nil

      {_, _} ->
        "#{feature_toggle.external_id}_#{feature_toggle.env}"
        |> atomize()
        |> FeatureTogglesCache.delete()
    end
  end

  def atomize(id) do
    cond do
      Kernel.is_bitstring(id) -> String.to_atom(id)
      Kernel.is_integer(id) -> String.to_atom(Integer.to_string(id))
    end
  end
end
