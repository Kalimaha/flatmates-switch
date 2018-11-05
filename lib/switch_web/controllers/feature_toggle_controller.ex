defmodule SwitchWeb.FeatureToggleController do
  use SwitchWeb, :controller

  alias SwitchWeb.FeatureToggleRepository

  def index(conn, _params) do
    feature_toggles = FeatureToggleRepository.list

    conn
    |> put_status(200)
    |> json(feature_toggles)
  end

  def create(conn, params) do
    { :ok, feature_toggle } = FeatureToggleRepository.save(params)

    conn
    |> put_status(:created)
    |> json(feature_toggle)
  end

  def delete(conn, params) do
    FeatureToggleRepository.delete(params["id"])

    conn
    |> put_status(:ok)
    |> json(:ok)
  end
end
