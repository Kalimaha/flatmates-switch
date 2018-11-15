defmodule SwitchWeb.FeatureToggle do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.{FeatureToggle, FeatureToggleRule}

  @derive {Poison.Encoder,
           only: [:id, :external_id, :env, :active, :type, :feature_toggle_rules, :label]}

  @valid_types ["simple", "attributes_based", "godsend", "attributes_based_godsend"]

  schema "feature_toggles" do
    field(:external_id, :string)
    field(:env, :string)
    field(:label, :string)
    field(:active, :boolean)
    field(:type, :string)
    has_many(:feature_toggle_rules, FeatureToggleRule)

    timestamps()
  end

  def changeset(%FeatureToggle{} = struct, attrs) do
    struct
    |> cast(attrs, [:external_id, :env, :active, :type, :label])
    |> validate_required([:external_id, :env, :active, :type, :label])
    |> validate_inclusion(:type, @valid_types)
  end
end
