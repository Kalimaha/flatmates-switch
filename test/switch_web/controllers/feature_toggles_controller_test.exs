defmodule SwitchWeb.FeatureTogglesControllerTest do
  use SwitchWeb.ConnCase

  alias SwitchWeb.{FeatureToggle, FeatureTogglesRepository}

  test "returns an empty array when there are no toggles available", %{conn: conn} do
    response = conn |> get(feature_toggles_path(conn, :index)) |> json_response(:ok)

    assert response == []
  end

  test "returns all the available feature toggles", %{conn: conn} do
    feature_toggles = [
      %{external_id: "spam", status: "active", env: "prod"},
      %{external_id: "eggs", status: "active", env: "prod"}
    ]

    [{:ok, toggle_1}, {:ok, toggle_2}] =
      Enum.map(feature_toggles, &FeatureTogglesRepository.save(&1))

    expected = [
      %{
        "external_id" => toggle_1.external_id,
        "status" => toggle_1.status,
        "env" => toggle_1.env
      },
      %{"external_id" => toggle_2.external_id, "status" => toggle_2.status, "env" => toggle_2.env}
    ]

    response = conn |> get(feature_toggles_path(conn, :index)) |> json_response(:ok)
    assert response == expected
  end

  test "inserts a new record in the DB", %{conn: conn} do
    feature_toggle = %{external_id: "spam", status: "test", env: "prod"}

    conn
    |> post(feature_toggles_path(conn, :create, feature_toggle), feature_toggle)
    |> json_response(:created)

    assert length(FeatureTogglesRepository.list()) == 1
  end

  test "attempt to insert a new record with invalid values", %{conn: conn} do
    feature_toggle = %{external_id: "spam"}

    response =
      conn
      |> post(feature_toggles_path(conn, :create, feature_toggle), feature_toggle)
      |> json_response(:unprocessable_entity)

    assert response["errors"] == %{"env" => ["can't be blank"], "status" => ["can't be blank"]}
  end

  test "deletes record from the DB", %{conn: conn} do
    feature_toggle = %{external_id: "spam", status: "active", env: "prod"}
    {:ok, record} = FeatureTogglesRepository.save(feature_toggle)

    conn
    |> delete(feature_toggles_path(conn, :delete, %FeatureToggle{id: record.id}))
    |> json_response(:ok)

    assert length(FeatureTogglesRepository.list()) == 0
  end

  test "updates existing records in the DB", %{conn: conn} do
    feature_toggle = %{external_id: "spam", status: "active", env: "prod"}
    {:ok, record} = FeatureTogglesRepository.save(feature_toggle)

    conn
    |> put(feature_toggles_path(conn, :update, record.id), %{
      :external_id => "eggs",
      :env => "test",
      :status => "rotten"
    })
    |> json_response(:ok)

    assert FeatureTogglesRepository.get(record.id).env == "test"
    assert FeatureTogglesRepository.get(record.id).status == "rotten"
    assert FeatureTogglesRepository.get(record.id).external_id == "eggs"
  end

  test "returns single feature toggle", %{conn: conn} do
    feature_toggle = %{external_id: "spam", status: "active", env: "prod"}
    {:ok, record} = FeatureTogglesRepository.save(feature_toggle)

    response = conn |> get(feature_toggles_path(conn, :show, record.id)) |> json_response(:ok)

    assert response == %{"env" => "prod", "external_id" => "spam", "status" => "active"}
  end

  test "attempt to get a missing model", %{conn: conn} do
    response = conn |> get(feature_toggles_path(conn, :show, 42)) |> json_response(:not_found)

    assert response == "not_found"
  end
end
