defmodule SwitchWeb.FeatureTogglesController do
  use SwitchWeb, :controller

  alias SwitchWeb.{FeatureTogglesRepository, ErrorHelpers}

  def index(%{assigns: %{version: :v1}} = conn, _params) do
    feature_toggles = FeatureTogglesRepository.list()

    conn
    |> put_status(:ok)
    |> json(feature_toggles)
  end

  def show(%{assigns: %{version: :v1}} = conn, params) do
    feature_toggle = FeatureTogglesRepository.get(params["id"])

    unless feature_toggle == nil do
      conn |> put_status(:ok) |> json(feature_toggle)
    else
      conn |> put_status(:not_found) |> json(:not_found)
    end
  end

  def create(%{assigns: %{version: :v1}} = conn, params) do
    with {:ok, feature_toggle} <- FeatureTogglesRepository.save(params) do
      conn
      |> put_status(:created)
      |> json(Switch.Repo.preload(feature_toggle, :feature_toggle_rules))
    else
      {:error, changeset} ->
        conn |> put_status(:unprocessable_entity) |> json(%{errors: translate_errors(changeset)})
    end
  end

  def delete(%{assigns: %{version: :v1}} = conn, params) do
    FeatureTogglesRepository.delete(params["id"])

    conn
    |> put_status(:ok)
    |> json(:ok)
  end

  def update(%{assigns: %{version: :v1}} = conn, params) do
    {:ok, feature_toggle} = FeatureTogglesRepository.update(params["id"], params)

    conn
    |> put_status(:ok)
    |> json(feature_toggle)
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
  end
end
