defmodule SwitchWeb.UserTest do
  use Switch.DataCase

  alias SwitchWeb.User

  test "changeset with valid attributes" do
    assert User.changeset(%User{}, %{}).valid?
  end
end
