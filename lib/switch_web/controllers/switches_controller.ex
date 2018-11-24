defmodule SwitchWeb.SwitchesController do
  use SwitchWeb, :controller

  alias SwitchWeb.SwitchesService

  def get_or_create(conn, %{
        "user_id" => user_id,
        "user_source" => user_source,
        "feature_toggle_name" => feature_toggle_name,
        "feature_toggle_env" => feature_toggle_env
      }) do
    case SwitchesService.get_or_create(
           user_id,
           user_source,
           feature_toggle_name,
           feature_toggle_env
         ) do
      {:ok, switch} ->
        conn |> put_status(:ok) |> json(Switch.Repo.preload(switch, :feature_toggle))

      {:error, message} ->
        conn |> put_status(:bad_request) |> json(message)
    end
  end

  def get_or_create(conn, _params) do
    conn |> put_status(:bad_request) |> json(:bad_request)
  end
end
