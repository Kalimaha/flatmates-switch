defmodule SwitchWeb.FeatureTogglesControllerTest do
  use SwitchWeb.ConnCase
  import Switch.Factory

  alias SwitchWeb.{FeatureToggle, FeatureTogglesRepository}

  test "returns an empty array when there are no toggles available", %{conn: conn} do
    response = conn |> get(feature_toggles_path(conn, :index)) |> json_response(:ok)

    assert response == []
  end

  test "returns all the available feature toggles", %{conn: conn} do
    feature_toggle = insert(:feature_toggle, payload: %{:spam => "eggs"})

    expected = [
      %{
        "external_id" => feature_toggle.external_id,
        "active" => feature_toggle.active,
        "env" => feature_toggle.env,
        "type" => feature_toggle.type,
        "feature_toggle_rules" => [],
        "id" => feature_toggle.id,
        "label" => feature_toggle.label,
        "payload" => %{"spam" => "eggs"}
      }
    ]

    response = conn |> get(feature_toggles_path(conn, :index)) |> json_response(:ok)
    assert response == expected
  end

  test "inserts a new record in the DB", %{conn: conn} do
    conn
    |> post(
      feature_toggles_path(conn, :create, params_for(:feature_toggle)),
      params_for(:feature_toggle)
    )
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
    feature_toggle = insert(:feature_toggle)

    conn
    |> delete(feature_toggles_path(conn, :delete, %FeatureToggle{id: feature_toggle.id}))
    |> json_response(:ok)

    assert length(FeatureTogglesRepository.list()) == 0
  end

  test "updates existing records in the DB", %{conn: conn} do
    feature_toggle = insert(:feature_toggle)

    conn
    |> put(feature_toggles_path(conn, :update, feature_toggle.id), %{
      :external_id => "eggs",
      :env => "test",
      :active => false,
      :type => "godsend"
    })
    |> json_response(:ok)

    assert FeatureTogglesRepository.get(id: feature_toggle.id).env == "test"
    assert FeatureTogglesRepository.get(id: feature_toggle.id).active == false
    assert FeatureTogglesRepository.get(id: feature_toggle.id).external_id == "eggs"
    assert FeatureTogglesRepository.get(id: feature_toggle.id).type == "godsend"
  end

  test "returns single feature toggle", %{conn: conn} do
    feature_toggle = insert(:feature_toggle)

    response =
      conn |> get(feature_toggles_path(conn, :show, feature_toggle.id)) |> json_response(:ok)

    assert response == %{
             "id" => feature_toggle.id,
             "env" => "dev",
             "external_id" => "spam",
             "active" => true,
             "type" => "simple",
             "label" => "Spam",
             "feature_toggle_rules" => [],
             "payload" => %{}
           }
  end

  test "returns single feature toggle with its rules", %{conn: conn} do
    feature_toggle = insert(:feature_toggle)

    FeatureTogglesRepository.add_rule(
      feature_toggle_id: feature_toggle.id,
      feature_toggle_rule_params: %{:threshold => 0.25}
    )

    response =
      conn |> get(feature_toggles_path(conn, :show, feature_toggle.id)) |> json_response(:ok)

    assert response == %{
             "id" => feature_toggle.id,
             "env" => "dev",
             "external_id" => "spam",
             "active" => true,
             "type" => "simple",
             "label" => "Spam",
             "feature_toggle_rules" => [
               %{
                 "attribute_name" => nil,
                 "attribute_operation" => nil,
                 "attribute_value" => nil,
                 "feature_toggle_id" => feature_toggle.id,
                 "threshold" => 0.25,
                 "type" => "simple"
               }
             ],
             "payload" => %{}
           }
  end

  test "attempt to get a missing model", %{conn: conn} do
    response = conn |> get(feature_toggles_path(conn, :show, 42)) |> json_response(:not_found)

    assert response == "not_found"
  end
end
