defmodule SwitchWeb.SwitchesService do
  alias SwitchWeb.{
    SwitchesRepository,
    UsersRepository,
    UsersCachedRepository,
    FeatureTogglesRepository
  }

  def get_or_create(user_external_id: user_external_id, user_source: user_source, feature_toggles: feature_toggles) do
    feature_toggles
    |> Flow.from_enumerable()
    |> Flow.map(
      &get_or_create(
        user_external_id: user_external_id,
        user_source: user_source,
        feature_toggle_name: &1["feature_toggle_name"],
        feature_toggle_env: &1["feature_toggle_env"]
      )
    )
    |> Flow.reduce(fn -> [] end, fn value, acc -> [parse_result(value) | acc] end)
    |> Enum.to_list()
  end

  def get_or_create(user_external_id: user_external_id, user_source: user_source, feature_toggle_name: feature_toggle_name, feature_toggle_env: feature_toggle_env) do
    feature_toggle =
      FeatureTogglesRepository.find_by_external_id_and_env(
        feature_toggle_name,
        feature_toggle_env
      )

    unless feature_toggle == nil do
      {:ok, user} = get_or_create_user(user_external_id, user_source)
      get_or_create_switch(user, feature_toggle)
    else
      {:error, "Feature toggle '#{feature_toggle_name}' (#{feature_toggle_env}) does not exist."}
    end
  end

  defp parse_result(result) do
    case result do
      {:ok, switch} -> Switch.Repo.preload(switch, feature_toggle: :feature_toggle_rules)
      {:error, message} -> %{error: message}
    end
  end

  defp get_or_create_switch(user, feature_toggle) do
    existing_switch =
      SwitchesRepository.get(
        user_external_id: user.external_id,
        user_source: user.source,
        feature_toggle_name: feature_toggle.external_id,
        feature_toggle_env: feature_toggle.env
      )

    case existing_switch do
      nil ->
        switch_payload(user, feature_toggle)
        |> SwitchesRepository.save()

      _ ->
        update_existing_switch(existing_switch, feature_toggle)
    end
  end

  defp update_existing_switch(existing_switch, feature_toggle) do
    updated_switch = %SwitchWeb.Switch{
      existing_switch
      | value: feature_toggle.active && existing_switch.value
    }

    {:ok, updated_switch}
  end

  defp get_or_create_user(user_id, user_source) do
    existing_user = UsersCachedRepository.get(external_id: user_id, user_source: user_source)

    case existing_user do
      nil -> UsersRepository.save(user: %{external_id: user_id, source: user_source})
      _ -> {:ok, existing_user}
    end
  end

  defp switch_payload(user, feature_toggle) do
    %{
      :user_id => user.external_id,
      :user_source => user.source,
      :feature_toggle_id => feature_toggle.id,
      :value => calculate_switch_value(feature_toggle)
    }
  end

  defp calculate_switch_value(feature_toggle) do
    case feature_toggle.type do
      "simple" ->
        feature_toggle.active

      "godsend" ->
        feature_toggle.active &&
          List.first(feature_toggle.feature_toggle_rules).threshold >= Enum.random(0..100) / 100.0

      _ ->
        false
    end
  end
end
