defmodule SwitchWeb.Switch do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.{Switch, FeatureToggle}

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
    |> validate_required([:feature_toggle_id])
    |> foreign_key_constraint(:feature_toggle_id)
  end

  defimpl Poison.Encoder, for: Switch do
    def encode(switch, options) do
      Poison.encode!(
        %{
          :id => switch.feature_toggle.external_id,
          :label => switch.feature_toggle.label,
          :value => switch.value,
          :user_id => switch.user_id,
          :user_source => switch.user_source,
          :env => switch.feature_toggle.env,
          :rules => switch.feature_toggle.feature_toggle_rules,
          :type => switch.feature_toggle.type,
          :payload => switch.feature_toggle.payload
        },
        options
      )
    end
  end
end
