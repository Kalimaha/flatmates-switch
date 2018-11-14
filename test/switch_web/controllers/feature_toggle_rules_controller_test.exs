defmodule SwitchWeb.FeatureToggleRulesControllerTest do
  use SwitchWeb.ConnCase

  alias SwitchWeb.{FeatureTogglesRepository, FeatureToggleRulesRepository}

  @feature_toggle %{external_id: "spam", status: "active", env: "prod", type: "simple"}

  test "returns an empty array when feature toggle is not found", %{conn: conn} do
    response =
      conn
      |> get(feature_toggles_feature_toggle_rules_path(conn, :index, 1))
      |> json_response(:ok)

    assert response == []
  end

  test "returns an empty array when feature toggle has no rules", %{conn: conn} do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)

    response =
      conn
      |> get(feature_toggles_feature_toggle_rules_path(conn, :index, record.id))
      |> json_response(:ok)

    assert response == []
  end

  test "returns rules associated with a feature toggle", %{conn: conn} do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)
    FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    response =
      conn
      |> get(feature_toggles_feature_toggle_rules_path(conn, :index, feature_toggle.id))
      |> json_response(:ok)

    assert response == [
             %{
               "threshold" => 0.42,
               "attribute_name" => nil,
               "attribute_operation" => nil,
               "attribute_value" => nil,
               "feature_toggle_id" => feature_toggle.id,
               "type" => "simple"
             }
           ]
  end

  test "deletes an existing rule", %{conn: conn} do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)
    {:ok, rule} = FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    response =
      conn
      |> delete(
        feature_toggles_feature_toggle_rules_path(conn, :delete, feature_toggle.id, rule.id)
      )
      |> json_response(:ok)

    assert response == []
  end

  test "attempt to delete a rule from a feature toggle that does not exist", %{conn: conn} do
    response =
      conn
      |> delete(feature_toggles_feature_toggle_rules_path(conn, :delete, 1, 1))
      |> json_response(:no_content)

    assert response == "Feature toggle with ID 1 not found."
  end

  test "attempt to delete a rule that does not exist", %{conn: conn} do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    response =
      conn
      |> delete(feature_toggles_feature_toggle_rules_path(conn, :delete, feature_toggle.id, 1))
      |> json_response(:no_content)

    assert response == "Feature toggle rule with ID 1 not found."
  end

  test "show a single rule", %{conn: conn} do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)
    {:ok, rule} = FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    response =
      conn
      |> get(feature_toggles_feature_toggle_rules_path(conn, :show, feature_toggle.id, rule.id))
      |> json_response(:ok)

    assert response == %{
             "attribute_name" => nil,
             "attribute_operation" => nil,
             "attribute_value" => nil,
             "feature_toggle_id" => feature_toggle.id,
             "threshold" => 0.42,
             "type" => "simple"
           }
  end

  test "attempt to show a single rule that does not exist", %{conn: conn} do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    response =
      conn
      |> get(feature_toggles_feature_toggle_rules_path(conn, :show, feature_toggle.id, 1))
      |> json_response(:no_content)

    assert response == "no_content"
  end

  test "attempt to show a single rule for a feature toggle that does not exist", %{conn: conn} do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    {:ok, rule} =
      FeatureToggleRulesRepository.save(%{
        :feature_toggle_id => feature_toggle.id,
        :type => "simple"
      })

    response =
      conn
      |> get(feature_toggles_feature_toggle_rules_path(conn, :show, 1, rule.id))
      |> json_response(:no_content)

    assert response == "no_content"
  end
end
