defmodule SwitchWeb.SwitchesController do
  use SwitchWeb, :controller

  alias SwitchWeb.SwitchesService

  def get_or_create(conn, params) do
    switch =
      SwitchesService.get_or_create(
        params["user_id"],
        params["user_source"],
        params["feature_toggle_name"],
        params["feature_toggle_env"]
      )

    conn |> put_status(:ok) |> json(switch)
  end
end
