defmodule SwitchWeb.FeatureTogglesRepositoryTest do
  use Switch.DataCase

  alias Switch.Repo
  alias SwitchWeb.{FeatureToggle, FeatureTogglesRepository}

  @feature_toggle %{
    :external_id => "spam",
    :active => true,
    :env => "bacon",
    :type => "simple",
    :label => "Spam"
  }

  test "save new content in the DB" do
    FeatureTogglesRepository.save(@feature_toggle)

    assert length(Repo.all(FeatureToggle)) == 1
  end

  test "assigns an ID to the record" do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)

    refute record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert length(FeatureTogglesRepository.list()) == 0
  end

  test "returns all the available records in the DB" do
    FeatureTogglesRepository.save(@feature_toggle)

    assert length(FeatureTogglesRepository.list()) == 1
  end

  test "updates an existing record in the DB" do
    {:ok, record} = FeatureTogglesRepository.save(@feature_toggle)
    FeatureTogglesRepository.update(record.id, %{:active => false, :env => "prod"})

    assert FeatureTogglesRepository.get(record.id).active == false
    assert FeatureTogglesRepository.get(record.id).env == "prod"
  end

  test "add rule to existing feature toggle" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)
    FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    assert length(FeatureTogglesRepository.get(feature_toggle.id).feature_toggle_rules) == 1

    assert Enum.map(
             FeatureTogglesRepository.get(feature_toggle.id).feature_toggle_rules,
             & &1.feature_toggle_id
           ) == [feature_toggle.id]

    assert Enum.map(
             FeatureTogglesRepository.get(feature_toggle.id).feature_toggle_rules,
             & &1.threshold
           ) == [0.42]
  end

  test "add rule to non-existing feature toggle" do
    with {:error, message} <- FeatureTogglesRepository.add_rule(42, %{:threshold => 0.42}) do
      assert message == "Feature toggle with ID 42 not found."
    end
  end

  test "update existing rule" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    {:ok, feature_toggle_rule} =
      FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    FeatureTogglesRepository.update_rule(feature_toggle.id, feature_toggle_rule.id, %{
      :threshold => 0.84
    })

    assert length(FeatureTogglesRepository.get(feature_toggle.id).feature_toggle_rules) == 1

    assert Enum.map(
             FeatureTogglesRepository.get(feature_toggle.id).feature_toggle_rules,
             & &1.threshold
           ) == [0.84]
  end

  test "update existing rule with wrong feature toggle" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    {:ok, feature_toggle_rule} =
      FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    with {:error, message} <-
           FeatureTogglesRepository.update_rule(42, feature_toggle_rule.id, %{:threshold => 0.84}) do
      assert message == "Feature toggle with ID 42 not found."
    end
  end

  test "delete existing rule" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    {:ok, feature_toggle_rule} =
      FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    FeatureTogglesRepository.remove_rule(feature_toggle.id, feature_toggle_rule.id)

    assert length(FeatureTogglesRepository.get(feature_toggle.id).feature_toggle_rules) == 0
  end

  test "delete existing rule with wrong feature toggle" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    {:ok, feature_toggle_rule} =
      FeatureTogglesRepository.add_rule(feature_toggle.id, %{:threshold => 0.42})

    FeatureTogglesRepository.remove_rule(42, feature_toggle_rule.id)

    with {:error, message} <- FeatureTogglesRepository.remove_rule(42, feature_toggle_rule.id) do
      assert message == "Feature toggle with ID 42 not found."
    end
  end

  test "delete non existing feature toggle rule" do
    {:ok, feature_toggle} = FeatureTogglesRepository.save(@feature_toggle)

    with {:error, message} <- FeatureTogglesRepository.remove_rule(feature_toggle.id, 42) do
      assert message == "Feature toggle rule with ID 42 not found."
    end
  end
end
