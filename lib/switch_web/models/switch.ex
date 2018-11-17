defmodule SwitchWeb.Switch do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.Switch

  @derive {Poison.Encoder,
           only: [
             :user_external_id,
             :user_source,
             :feature_toggle_name,
             :feature_toggle_env,
             :value
           ]}

  schema "switches" do
    field(:user_id, :string, source: :user_external_id)
    field(:user_source, :string)
    field(:feature_toggle_name, :string)
    field(:feature_toggle_env, :string)
    field(:value, :boolean)

    timestamps()
  end

  def changeset(%Switch{} = struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :user_source, :feature_toggle_name, :feature_toggle_env, :value])
    |> validate_required([:user_id])
  end
end
