defmodule SwitchWeb.FeatureToggleControllerTest do
  use SwitchWeb.ConnCase

  alias SwitchWeb.{ FeatureToggle, FeatureToggleRepository}

  test "returns an empty array when there are no toggles available", %{conn: conn} do
    response = conn |> get(feature_toggle_path(conn, :index)) |> json_response(200)

    assert response == []
  end

  test "returns all the available feature toggles", %{conn: conn} do
    feature_toggles = [
      %{ external_id: "spam", status: "active", env: "prod" },
      %{ external_id: "eggs", status: "active", env: "prod" }
    ]

    [{:ok, toggle_1}, {:ok, toggle_2}] = Enum.map(feature_toggles, &FeatureToggleRepository.save(&1))

    response = conn |> get(feature_toggle_path(conn, :index)) |> json_response(200)

    expected = [
      %{ "external_id" => toggle_1.external_id, "status" => toggle_1.status, "env" => toggle_1.env },
      %{ "external_id" => toggle_2.external_id, "status" => toggle_2.status, "env" => toggle_2.env }
    ]

    assert response == expected
  end

  test "inserts a new record in the DB", %{conn: conn} do
    feature_toggle = %{ external_id: "spam", status: "active", env: "prod" }
    conn |> post(feature_toggle_path(conn, :create, feature_toggle)) |> json_response(201)

    assert (length FeatureToggleRepository.list) == 1
  end

  test "deletes record from the DB", %{conn: conn} do
    feature_toggle = %{ external_id: "spam", status: "active", env: "prod" }
    { :ok, record } = FeatureToggleRepository.save(feature_toggle)

    conn |> delete(feature_toggle_path(conn, :delete, %FeatureToggle{ id: record.id })) |> json_response(200)

    assert (length FeatureToggleRepository.list) == 0
  end
end
