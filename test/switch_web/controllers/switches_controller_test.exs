defmodule SwitchWeb.SwitchesControllerTest do
  use SwitchWeb.ConnCase
  import Switch.Factory

  alias SwitchWeb.{UsersRepository, SwitchesRepository}

  test "returns an existing switch", %{conn: conn} do
    user = insert(:user)
    feature_toggle = insert(:feature_toggle)

    switch =
      insert(:switch,
        user_id: user.external_id,
        user_source: user.source,
        feature_toggle_id: feature_toggle.id
      )

    payload = %{
      :user_id => switch.user_id,
      :user_source => switch.user_source,
      :feature_toggle_name => feature_toggle.external_id,
      :feature_toggle_env => feature_toggle.env
    }

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:ok)

    assert response == %{
             "user_source" => "flatmates",
             "value" => true,
             "feature_toggle" => %{
               "active" => true,
               "env" => "dev",
               "external_id" => "spam",
               "feature_toggle_rules" => [],
               "id" => feature_toggle.id,
               "label" => "Spam",
               "type" => "simple",
               "payload" => %{}
             }
           }
  end

  test "creates a switch and an user if it does not exist in the DB already", %{conn: conn} do
    feature_toggle = insert(:feature_toggle, active: true)

    payload = %{
      :user_id => "user_123",
      :user_source => "a_nice_system",
      :feature_toggle_name => feature_toggle.external_id,
      :feature_toggle_env => feature_toggle.env
    }

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:ok)

    assert length(UsersRepository.list()) == 1
    assert length(SwitchesRepository.list()) == 1

    assert response == %{
             "user_source" => "a_nice_system",
             "value" => true,
             "feature_toggle" => %{
               "active" => true,
               "env" => "dev",
               "external_id" => "spam",
               "feature_toggle_rules" => [],
               "id" => feature_toggle.id,
               "label" => "Spam",
               "type" => "simple",
               "payload" => %{}
             }
           }
  end

  test "attempt to get a switch for a toggle that does not exist", %{conn: conn} do
    payload = %{
      :user_id => "user_123",
      :user_source => "a_nice_system",
      :feature_toggle_name => "non_existing_toggle",
      :feature_toggle_env => "prod"
    }

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:bad_request)

    assert response == "Feature toggle 'non_existing_toggle' (prod) does not exist."
  end

  test "attempts to call the endpoint with wrong params", %{conn: conn} do
    payload = %{:hallo => "world"}

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:bad_request)

    assert response == "bad_request"
  end
end
