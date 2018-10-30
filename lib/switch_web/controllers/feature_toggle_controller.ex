defmodule SwitchWeb.FeatureToggleController do
  use SwitchWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> json([])
  end
end
