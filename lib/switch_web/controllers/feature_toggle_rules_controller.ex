defmodule SwitchWeb.FeatureToggleRulesController do
  use SwitchWeb, :controller

  alias SwitchWeb.{
    FeatureTogglesRepository,
    FeatureToggleRulesRepository,
    FeatureTogglesCachedRepository
  }

  def index(%{assigns: %{version: :v1}} = conn, params) do
    feature_toggle = FeatureTogglesCachedRepository.get(id: params["feature_toggles_id"])

    case feature_toggle do
      nil -> conn |> put_status(:ok) |> json([])
      _ -> conn |> put_status(:ok) |> json(feature_toggle.feature_toggle_rules)
    end
  end

  def show(%{assigns: %{version: :v1}} = conn, params) do
    feature_toggle = FeatureTogglesCachedRepository.get(id: params["feature_toggles_id"])
    feature_toggle_rule = FeatureToggleRulesRepository.get(id: params["id"])

    case {feature_toggle, feature_toggle_rule} do
      {nil, _} -> conn |> put_status(:no_content) |> json(:no_content)
      {_, nil} -> conn |> put_status(:no_content) |> json(:no_content)
      {_, _} -> conn |> put_status(:ok) |> json(feature_toggle_rule)
    end
  end

  def delete(%{assigns: %{version: :v1}} = conn, params) do
    with {:ok, _} <-
           FeatureTogglesRepository.remove_rule(
             feature_toggle_id: params["feature_toggles_id"],
             feature_toggle_rule_id: params["id"]
           ) do
      feature_toggle = FeatureTogglesCachedRepository.get(id: params["feature_toggles_id"])

      conn |> put_status(:ok) |> json(feature_toggle.feature_toggle_rules)
    else
      {:error, message} -> conn |> put_status(:no_content) |> json(message)
    end
  end

  def create(%{assigns: %{version: :v1}} = conn, params) do
    feature_toggle = FeatureTogglesCachedRepository.get(id: params["feature_toggles_id"])

    unless feature_toggle == nil do
      {:ok, rule} =
        FeatureTogglesRepository.add_rule(
          feature_toggle_id: feature_toggle.id,
          feature_toggle_rule_params: params
        )

      conn
      |> put_status(:created)
      |> json(rule)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(:unprocessable_entity)
    end
  end

  def update(%{assigns: %{version: :v1}} = conn, params) do
    with {:ok, rule} <-
           FeatureTogglesRepository.update_rule(
             feature_toggle_id: params["feature_toggles_id"],
             feature_toggle_rule_id: params["id"],
             feature_toggle_rule_params: params
           ) do
      conn
      |> put_status(:ok)
      |> json(rule)
    else
      {:error, message} -> conn |> put_status(:not_found) |> json(message)
    end
  end
end
