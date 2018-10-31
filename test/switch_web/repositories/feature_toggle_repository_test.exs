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
end
