# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Switch.Repo.insert!(%Switch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule SwitchWeb.Seeder do
  alias Switch.Repo
  alias SwitchWeb.{User, UsersRepository, FeatureToggle, FeatureTogglesRepository}

  def seed_data do
    clear_all()

    user_1 = %{:external_id => "tizio", :source => "flatmates"}
    user_2 = %{:external_id => "cazio", :source => "flatmates"}
    user_3 = %{:external_id => "sempronio", :source => "flatmates"}

    UsersRepository.save(user_1)
    UsersRepository.save(user_2)
    UsersRepository.save(user_3)

    feature_toggle_1 = %{:external_id => "toggle_1", :active => true, :env => "dev", :type => "simple", :label => "Toggle 1"}
    feature_toggle_2 = %{:external_id => "toggle_2", :active => true, :env => "test", :type => "simple", :label => "Toggle 2"}
    feature_toggle_3 = %{:external_id => "toggle_3", :active => true, :env => "prod", :type => "simple", :label => "Toggle 3"}

    FeatureTogglesRepository.save(feature_toggle_1)
    FeatureTogglesRepository.save(feature_toggle_2)
    FeatureTogglesRepository.save(feature_toggle_3)
  end

  defp clear_all do
    Repo.delete_all(User)
    Repo.delete_all(FeatureToggle)
  end
end

SwitchWeb.Seeder.seed_data()
