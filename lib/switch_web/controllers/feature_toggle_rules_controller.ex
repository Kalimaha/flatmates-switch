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
      {nil, _} -> conn |> put_status(:no_content) |> json(:no_content)
      {_, nil} -> conn |> put_status(:no_content) |> json(:no_content)
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

  def create(conn, params) do
    feature_toggle = FeatureTogglesRepository.get(params["feature_toggles_id"])

    unless feature_toggle == nil do
      {:ok, rule} = FeatureTogglesRepository.add_rule(feature_toggle.id, params)

      conn
      |> put_status(:created)
      |> json(rule)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(:unprocessable_entity)
    end
  end

  def update(conn, params) do
    with {:ok, rule} <-
           FeatureTogglesRepository.update_rule(
             params["feature_toggles_id"],
             params["id"],
             params
           ) do
      conn
      |> put_status(:ok)
      |> json(rule)
    else
      {:error, message} -> conn |> put_status(:not_found) |> json(message)
    end
  end
end
