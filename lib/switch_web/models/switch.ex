defmodule SwitchWeb.Switch do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.{Switch, FeatureToggle}

  @derive {Poison.Encoder,
           only: [
             :user_external_id,
             :user_source,
             :feature_id,
             :value
           ]}

  schema "switches" do
    field(:user_id, :string, source: :user_external_id)
    field(:user_source, :string)
    field(:value, :boolean)
    belongs_to(:feature_toggle, FeatureToggle)

    timestamps()
  end

  def changeset(%Switch{} = struct, attrs) do
    struct
    |> cast(attrs, [:feature_toggle_id, :user_id, :user_source, :value])
    |> validate_required([:user_id])
  end
end
