defmodule SwitchWeb.FeatureToggleRepositoryTest do
  use Switch.DataCase

  alias Switch.Repo
  alias SwitchWeb.{ FeatureToggle, FeatureToggleRepository }

  @feature_toggle %{
    :external_id => "spam",
    :status => "eggs",
    :env => "bacon"
  }

  test "save new content in the DB" do
    FeatureToggleRepository.save(@feature_toggle)

    assert (length Repo.all FeatureToggle) == 1
  end

  test "assigns an ID to the record" do
    { :ok, record } = FeatureToggleRepository.save(@feature_toggle)

    refute record.id == nil
  end

  test "returns an empty array when there are no records in the DB" do
    assert (length FeatureToggleRepository.list) == 0
  end

  test "returns all the available records in the DB" do
    FeatureToggleRepository.save(@feature_toggle)

    assert (length FeatureToggleRepository.list) == 1
  end

  test "updates an existing record in the DB" do
    { :ok, record } = FeatureToggleRepository.save(@feature_toggle)
    FeatureToggleRepository.update(record.id, %{ :status => "bacon", :env => "prod" })

    assert FeatureToggleRepository.get(record.id).status == "bacon"
    assert FeatureToggleRepository.get(record.id).env == "prod"
  end
end
