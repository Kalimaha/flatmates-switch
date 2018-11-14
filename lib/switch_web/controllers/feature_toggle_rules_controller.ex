defmodule SwitchWeb.FeatureToggleRulesController do
  use SwitchWeb, :controller

  alias SwitchWeb.{FeatureTogglesRepository, FeatureToggleRulesRepository}

  def index(conn, params) do
    feature_toggle = FeatureTogglesRepository.get(params["feature_toggles_id"])

    case feature_toggle do
      nil -> conn |> put_status(:ok) |> json([])
      _ -> conn |> put_status(:ok) |> json(feature_toggle.feature_toggle_rules)
    end
  end

  def show(conn, params) do
    feature_toggle = FeatureTogglesRepository.get(params["feature_toggles_id"])
    feature_toggle_rule = FeatureToggleRulesRepository.get(params["id"])

    case {feature_toggle, feature_toggle_rule} do
      {nil, nil} -> conn |> put_status(:no_content) |> json(:no_content)
      {_, nil} -> conn |> put_status(:no_content) |> json(:no_content)
      {nil, _} -> conn |> put_status(:no_content) |> json(:no_content)
      {_, _} -> conn |> put_status(:ok) |> json(feature_toggle_rule)
    end
  end

  def delete(conn, params) do
    with {:ok, _} <-
           FeatureTogglesRepository.remove_rule(params["feature_toggles_id"], params["id"]) do
      feature_toggle = FeatureTogglesRepository.get(params["feature_toggles_id"])

      conn |> put_status(:ok) |> json(feature_toggle.feature_toggle_rules)
    else
      {:error, message} -> conn |> put_status(:no_content) |> json(message)
    end
  end
end
