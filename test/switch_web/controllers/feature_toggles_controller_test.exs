defmodule SwitchWeb.FeatureTogglesControllerTest do
  use SwitchWeb.ConnCase

  alias SwitchWeb.{FeatureToggle, FeatureTogglesRepository}

  @feature_toggle %{external_id: "spam", active: true, env: "prod", type: "simple", label: "Spam"}

  test "returns an empty array when there are no toggles available", %{conn: conn} do
    response = conn |> get(feature_toggles_path(conn, :index)) |> json_response(:ok)

    assert response == []
  end

  test "returns all the available feature toggles", %{conn: conn} do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)

    expected = [
      %{
        "external_id" => record.external_id,
        "active" => record.active,
        "label" => record.label,
        "env" => record.env,
        "type" => record.type,
        "feature_toggle_rules" => [],
        "id" => record.id
      }
    ]

    response = conn |> get(feature_toggles_path(conn, :index)) |> json_response(:ok)
    assert response == expected
  end

  test "inserts a new record in the DB", %{conn: conn} do
    conn
    |> post(feature_toggles_path(conn, :create, @feature_toggle), @feature_toggle)
    |> json_response(:created)

    assert length(FeatureTogglesRepository.list()) == 1
  end

  test "attempt to insert a new record with invalid values", %{conn: conn} do
    feature_toggle = %{external_id: "spam"}

    response =
      conn
      |> post(feature_toggles_path(conn, :create, feature_toggle), feature_toggle)
      |> json_response(:unprocessable_entity)

    assert response["errors"] == %{
             "env" => ["can't be blank"],
             "active" => ["can't be blank"],
             "label" => ["can't be blank"],
             "type" => ["can't be blank"]
           }
  end

  test "deletes record from the DB", %{conn: conn} do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)

    conn
    |> delete(feature_toggles_path(conn, :delete, %FeatureToggle{id: record.id}))
    |> json_response(:ok)

    assert length(FeatureTogglesRepository.list()) == 0
  end

  test "updates existing records in the DB", %{conn: conn} do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)

    conn
    |> put(feature_toggles_path(conn, :update, record.id), %{
      :external_id => "eggs",
      :env => "test",
      :active => false,
      :type => "godsend"
    })
    |> json_response(:ok)

    assert FeatureTogglesRepository.get(record.id).env == "test"
    assert FeatureTogglesRepository.get(record.id).active == false
    assert FeatureTogglesRepository.get(record.id).external_id == "eggs"
    assert FeatureTogglesRepository.get(record.id).type == "godsend"
  end

  test "returns single feature toggle", %{conn: conn} do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)

    response = conn |> get(feature_toggles_path(conn, :show, record.id)) |> json_response(:ok)

    assert response == %{
             "id" => record.id,
             "env" => "prod",
             "external_id" => "spam",
             "active" => true,
             "type" => "simple",
             "label" => "Spam",
             "feature_toggle_rules" => []
           }
  end

  test "returns single feature toggle with its rules", %{conn: conn} do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)
    FeatureTogglesRepository.add_rule(record.id, %{:threshold => 0.25})

    response = conn |> get(feature_toggles_path(conn, :show, record.id)) |> json_response(:ok)

    assert response == %{
             "id" => record.id,
             "env" => "prod",
             "external_id" => "spam",
             "active" => true,
             "type" => "simple",
             "label" => "Spam",
             "feature_toggle_rules" => [
               %{
                 "attribute_name" => nil,
                 "attribute_operation" => nil,
                 "attribute_value" => nil,
                 "feature_toggle_id" => record.id,
                 "threshold" => 0.25,
                 "type" => "simple"
               }
             ]
           }
  end

  test "attempt to get a missing model", %{conn: conn} do
    response = conn |> get(feature_toggles_path(conn, :show, 42)) |> json_response(:not_found)

    assert response == "not_found"
  end
end
