defmodule SwitchWeb.SwitchesController do
  use SwitchWeb, :controller

  alias SwitchWeb.SwitchesRepository

  def get_or_create(conn, params) do
    switch =
      SwitchesRepository.find_by(
        params["user_id"],
        params["user_source"],
        params["feature_toggle_name"],
        params["feature_toggle_env"]
      )

    conn |> put_status(:ok) |> json(switch)
  end
end
