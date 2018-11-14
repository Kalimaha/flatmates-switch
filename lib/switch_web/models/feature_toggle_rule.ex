defmodule SwitchWeb.FeatureToggleRule do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.{FeatureToggle, FeatureToggleRule}

  @derive {Poison.Encoder,
           only: [
             :feature_toggle_id,
             :attribute_name,
             :attribute_value,
             :attribute_operation,
             :threshold
           ]}

  schema "feature_toggle_rules" do
    field(:attribute_name, :string)
    field(:attribute_value, :float)
    field(:attribute_operation, :string)
    field(:threshold, :float)
    belongs_to(:feature_toggle, FeatureToggle)

    timestamps()
  end

  def changeset(%FeatureToggleRule{} = struct, attrs) do
    struct
    |> cast(attrs, [
      :feature_toggle_id,
      :attribute_name,
      :attribute_value,
      :attribute_operation,
      :threshold
    ])
    |> validate_required([:feature_toggle_id])
    |> validate_number(:threshold, less_than_or_equal_to: 1.0, greater_than_or_equal_to: 0.0)
  end
end
