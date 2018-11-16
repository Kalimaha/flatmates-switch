defmodule Switch.Factory do
  use ExMachina.Ecto, repo: Switch.Repo

  def user_factory do
    %SwitchWeb.User{:external_id => "spam", :source => "flatmates"}
  end

  def feature_toggle_factory do
    %SwitchWeb.FeatureToggle{
      :external_id => "spam",
      :status => "eggs",
      :env => "bacon",
      :type => "simple"
    }
  end

  def feature_toggle_rule_factory do
    %SwitchWeb.FeatureToggleRule{:type => "simple"}
  end

  def switch_factory do
    %SwitchWeb.Switch{:feature_toggle_name => "spam", :value => true}
  end
end
