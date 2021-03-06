defmodule SwitchWeb.SwitchesControllerTest do
  use SwitchWeb.ConnCase

  import Switch.Factory

  alias Switch.{FeatureTogglesCache, SwitchesCache}
  alias SwitchWeb.{UsersRepository, SwitchesRepository}

  setup do
    SwitchesCache.delete_all()
    FeatureTogglesCache.delete_all()
  end

  test "multiple switches", %{conn: conn} do
    user = insert(:user)
    feature_toggle_1 = insert(:feature_toggle, external_id: "spam")
    feature_toggle_2 = insert(:feature_toggle, external_id: "eggs", label: "Eggs")

    insert(:switch,
      user_id: user.external_id,
      user_source: user.source,
      feature_toggle_id: feature_toggle_1.id
    )

    payload = %{
      :user_id => user.external_id,
      :user_source => user.source,
      :feature_toggles => [
        %{
          :feature_toggle_name => feature_toggle_1.external_id,
          :feature_toggle_env => feature_toggle_1.env
        },
        %{
          :feature_toggle_name => feature_toggle_2.external_id,
          :feature_toggle_env => feature_toggle_2.env
        }
      ]
    }

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:ok)

    assert Enum.sort_by(response, & &1["id"]) == [
             %{
               "id" => feature_toggle_2.external_id,
               "label" => feature_toggle_2.label,
               "value" => true,
               "user_id" => user.external_id,
               "user_source" => "flatmates",
               "env" => "dev",
               "rules" => [],
               "type" => "simple",
               "payload" => %{}
             },
             %{
               "id" => feature_toggle_1.external_id,
               "label" => feature_toggle_1.label,
               "value" => true,
               "user_id" => user.external_id,
               "user_source" => "flatmates",
               "env" => "dev",
               "rules" => [],
               "type" => "simple",
               "payload" => %{}
             }
           ]
  end

  test "multiple switches, with error", %{conn: conn} do
    user = insert(:user)
    feature_toggle_1 = insert(:feature_toggle, external_id: "spam")
    feature_toggle_2 = insert(:feature_toggle, external_id: "eggs", label: "Eggs")

    insert(:switch,
      user_id: user.external_id,
      user_source: user.source,
      feature_toggle_id: feature_toggle_1.id
    )

    payload = %{
      :user_id => user.external_id,
      :user_source => user.source,
      :feature_toggles => [
        %{
          :feature_toggle_name => "I_DO_NOT_EXIST",
          :feature_toggle_env => feature_toggle_1.env
        },
        %{
          :feature_toggle_name => feature_toggle_2.external_id,
          :feature_toggle_env => feature_toggle_2.env
        }
      ]
    }

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:ok)

    assert Enum.sort_by(response, & &1["id"]) == [
             %{
               "error" => "Feature toggle 'I_DO_NOT_EXIST' (dev) does not exist."
             },
             %{
               "id" => feature_toggle_2.external_id,
               "label" => feature_toggle_2.label,
               "value" => true,
               "user_id" => user.external_id,
               "user_source" => "flatmates",
               "env" => "dev",
               "rules" => [],
               "type" => "simple",
               "payload" => %{}
             }
           ]
  end

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
             "id" => feature_toggle.external_id,
             "label" => feature_toggle.label,
             "value" => true,
             "user_id" => user.external_id,
             "user_source" => "flatmates",
             "env" => "dev",
             "rules" => [],
             "type" => "simple",
             "payload" => %{}
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
             "env" => "dev",
             "id" => "spam",
             "label" => "Spam",
             "payload" => %{},
             "rules" => [],
             "type" => "simple",
             "user_id" => "user_123"
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

  test "creates a simple switch without an user if it does not exist in the DB already", %{
    conn: conn
  } do
    feature_toggle = insert(:feature_toggle, active: true)

    payload = %{
      :feature_toggle_name => feature_toggle.external_id,
      :feature_toggle_env => feature_toggle.env
    }

    response =
      conn
      |> get(switches_path(conn, :get_or_create), payload)
      |> json_response(:ok)

    assert length(UsersRepository.list()) == 0
    assert length(SwitchesRepository.list()) == 1

    assert response == %{
             "user_source" => nil,
             "value" => true,
             "env" => "dev",
             "id" => "spam",
             "label" => "Spam",
             "payload" => %{},
             "rules" => [],
             "type" => "simple",
             "user_id" => nil
           }
  end
end
