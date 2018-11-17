defmodule SwitchWeb.SwitchesControllerTest do
  use SwitchWeb.ConnCase
  import Switch.Factory

  alias SwitchWeb.SwitchesRepository

  test "returns an existing switch", %{conn: conn} do
    switch = insert(:switch)
    payload = params_for(:switch)

    response =
      conn
      |> post(switches_path(conn, :get_or_create), payload)
      |> json_response(:ok)

    assert response == %{
             "feature_toggle_env" => "prod",
             "feature_toggle_name" => "spam",
             "user_source" => "flatmates",
             "value" => true
           }
  end
end
