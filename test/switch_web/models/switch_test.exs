defmodule SwitchWeb.SwitchTest do
  use Switch.DataCase

  alias SwitchWeb.Switch

  test "changeset with invalid attributes" do
    refute Switch.changeset(%Switch{}, %{}).valid?
  end

  test "changeset with valid attributes" do
    assert Switch.changeset(%Switch{:user_id => 42, :feature_toggle_id => 23}, %{}).valid?
  end
end
