defmodule SwitchWeb.FeatureToggleController do
  use SwitchWeb, :controller

  alias SwitchWeb.{FeatureToggleRepository, ErrorHelpers}

  def index(conn, _params) do
    feature_toggles = FeatureToggleRepository.list()

    conn
    |> put_status(:ok)
    |> json(feature_toggles)
  end

  def show(conn, params) do
    feature_toggle = FeatureToggleRepository.get(params["id"])

    conn
    |> put_status(:ok)
    |> json(feature_toggle)
  end

  def create(conn, params) do
    with {:ok, feature_toggle} <- FeatureToggleRepository.save(params) do
      conn
      |> put_status(:created)
      |> json(feature_toggle)
    else
      {:error, changeset} ->
        conn |> put_status(:unprocessable_entity) |> json(%{errors: translate_errors(changeset)})
    end
  end

  def delete(conn, params) do
    FeatureToggleRepository.delete(params["id"])

    conn
    |> put_status(:ok)
    |> json(:ok)
  end

  def update(conn, params) do
    {:ok, feature_toggle} = FeatureToggleRepository.update(params["id"], params)

    conn
    |> put_status(:ok)
    |> json(feature_toggle)
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
  end
end
