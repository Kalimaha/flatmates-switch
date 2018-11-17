defmodule SwitchWeb.SwitchesControllerTest do
  use SwitchWeb.ConnCase
  import Switch.Factory

  alias SwitchWeb.UsersRepository

  test "returns an existing switch", %{conn: conn} do
    user = insert(:user)
    feature_toggle = insert(:feature_toggle)

    switch =
      insert(:switch,
        user_id: user.external_id,
        user_source: user.source,
        feature_toggle_name: feature_toggle.external_id,
        feature_toggle_env: feature_toggle.env
      )

    payload = %{
      :user_id => switch.user_id,
      :user_source => switch.user_source,
      :feature_toggle_name => switch.feature_toggle_name,
      :feature_toggle_env => switch.feature_toggle_env
    }

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:ok)

    assert response == %{
             "feature_toggle_env" => "bacon",
             "feature_toggle_name" => "spam",
             "user_source" => "flatmates",
             "value" => true
           }
  end

  test "creates the user if it does not exist in the DB already", %{conn: conn} do
    feature_toggle = insert(:feature_toggle)

    switch =
      insert(:switch,
        user_id: "user_123",
        user_source: "a_nice_system",
        feature_toggle_name: feature_toggle.external_id,
        feature_toggle_env: feature_toggle.env
      )

    payload = %{
      :user_id => switch.user_id,
      :user_source => switch.user_source,
      :feature_toggle_name => switch.feature_toggle_name,
      :feature_toggle_env => switch.feature_toggle_env
    }

    conn
    |> get(switches_path(conn, :get_or_create), payload)
    |> json_response(:ok)

    assert length(UsersRepository.list()) == 1
  end
end
