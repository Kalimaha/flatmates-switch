defmodule SwitchWeb.SwitchesControllerTest do
  use SwitchWeb.ConnCase
  import Switch.Factory

  alias SwitchWeb.{SwitchesRepository, SwitchesRepository}

  test "returns an empty array when there are no switches available", %{conn: conn} do
    response =
      conn
      |> get(users_switches_path(conn, :index, 1))
      |> json_response(:ok)

    assert response == []
  end

  test "returns available switches", %{conn: conn} do
    user = insert(:user)
    switch = insert(:switch, user_id: user.id)

    response =
      conn
      |> get(users_switches_path(conn, :index, user.id))
      |> json_response(:ok)

    assert response == [%{"feature_toggle_name" => "spam", "user_id" => user.id, "value" => true}]
  end

  test "attempt to fetch available switches for non-existent user", %{conn: conn} do
    user = insert(:user)
    switch = insert(:switch, user_id: user.id)

    response =
      conn
      |> get(users_switches_path(conn, :index, 42))
      |> json_response(:ok)

    assert response == []
  end
end
