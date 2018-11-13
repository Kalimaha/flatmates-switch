defmodule SwitchWeb.FeatureToggle do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.FeatureToggle

  @derive {Poison.Encoder, only: [:external_id, :env, :status, :type]}

  @valid_types ["simple", "attributes_based", "godsend", "attributes_based_godsend"]

  schema "feature_toggles" do
    field(:external_id, :string)
    field(:env, :string)
    field(:status, :string)
    field(:type, :string)

    timestamps()
  end

  def changeset(%FeatureToggle{} = struct, attrs) do
    struct
    |> cast(attrs, [:external_id, :env, :status, :type])
    |> validate_required([:external_id, :env, :status, :type])
    |> validate_inclusion(:type, @valid_types)
  end
end
