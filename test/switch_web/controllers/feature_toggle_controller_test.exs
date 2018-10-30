defmodule SwitchWeb.FeatureToggleControllerTest do
  use SwitchWeb.ConnCase

  test "returns all the feature toggles", %{conn: conn} do
    response =
      conn
      |> get(feature_toggle_path(conn, :index))
      |> json_response(200)

    assert response == []
  end
end
