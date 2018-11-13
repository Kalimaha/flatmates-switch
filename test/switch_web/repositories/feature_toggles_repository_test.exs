defmodule SwitchWeb.FeatureTogglesRepositoryTest do
  use Switch.DataCase

  alias Switch.Repo
  alias SwitchWeb.{FeatureToggle, FeatureTogglesRepository}

  @feature_toggle %{
    :external_id => "spam",
    :status => "eggs",
    :env => "bacon",
    :type => "simple"
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
    FeatureTogglesRepository.update(record.id, %{:status => "bacon", :env => "prod"})

    assert FeatureTogglesRepository.get(record.id).status == "bacon"
    assert FeatureTogglesRepository.get(record.id).env == "prod"
  end
end
