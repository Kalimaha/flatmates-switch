defmodule SwitchWeb.FeatureToggle do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.FeatureToggle

  @derive {Poison.Encoder, only: [:external_id, :env, :status]}
  schema "feature_toggles" do
    field :external_id, :string
    field :env,         :string
    field :status,      :string

    timestamps()
  end

  def changeset(%FeatureToggle{} = struct, attrs) do
    struct
    |> cast(attrs, [:external_id, :env, :status])
  end
end
