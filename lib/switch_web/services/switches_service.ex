defmodule SwitchWeb.SwitchesService do
  alias SwitchWeb.{SwitchesRepository, UsersRepository, FeatureTogglesRepository}

  def get_or_create(user_id, user_source, feature_toggle_name, feature_toggle_env) do
    feature_toggle =
      FeatureTogglesRepository.find_by_external_id_and_env(
        feature_toggle_name,
        feature_toggle_env
      )

    unless feature_toggle == nil do
      {:ok, user} = get_or_create_user(user_id, user_source)
      get_or_create_switch(user, feature_toggle)
    else
      {:error, "Feature toggle '#{feature_toggle_name}' (#{feature_toggle_env}) does not exist."}
    end
  end

  defp get_or_create_switch(user, feature_toggle) do
    existing_switch =
      SwitchesRepository.find_by(
        user.external_id,
        user.source,
        feature_toggle.external_id,
        feature_toggle.env
      )

    case existing_switch do
      nil ->
        SwitchesRepository.save(switch_payload(user, feature_toggle))

      _ ->
        update_existing_switch(existing_switch, feature_toggle)
    end
  end

  defp update_existing_switch(existing_switch, feature_toggle) do
    updated_switch = %SwitchWeb.Switch{existing_switch | value: feature_toggle.active}
    {:ok, updated_switch}
  end

  defp get_or_create_user(user_id, user_source) do
    existing_user = UsersRepository.find_by_external_id_and_source(user_id, user_source)

    case existing_user do
      nil -> UsersRepository.save(%{external_id: user_id, source: user_source})
      _ -> {:ok, existing_user}
    end
  end

  defp switch_payload(user, feature_toggle) do
    %{
      :user_id => user.external_id,
      :user_source => user.source,
      :feature_toggle_name => feature_toggle.external_id,
      :feature_toggle_env => feature_toggle.env,
      :value => feature_toggle.active
    }
  end
end
