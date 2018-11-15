defmodule SwitchWeb.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.User

  @derive {Poison.Encoder, only: [:id, :external_id, :source]}

  schema "users" do
    field(:external_id, :string)
    field(:source, :string)

    timestamps()
  end

  def changeset(%User{} = struct, attrs) do
    struct
    |> cast(attrs, [:external_id, :source])
  end
end
