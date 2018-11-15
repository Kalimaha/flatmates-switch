defmodule SwitchWeb.Switch do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.Switch

  @derive {Poison.Encoder, only: [:user_id, :feature_toggle_name, :value]}

  schema "switches" do
    field(:user_id, :id)
    field(:feature_toggle_name, :string)
    field(:value, :boolean)

    timestamps()
  end

  def changeset(%Switch{} = struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :feature_toggle_name, :value])
    |> validate_required([:user_id])
  end
end
