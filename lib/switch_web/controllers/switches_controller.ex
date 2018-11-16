defmodule SwitchWeb.SwitchesController do
  use SwitchWeb, :controller

  alias SwitchWeb.SwitchesRepository

  def index(conn, params) do
    switches = SwitchesRepository.list(params["users_id"])

    conn |> put_status(:ok) |> json(switches)
  end
end
