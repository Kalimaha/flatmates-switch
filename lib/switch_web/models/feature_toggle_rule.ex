defmodule SwitchWeb.FeatureToggleRule do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwitchWeb.{FeatureToggle, FeatureToggleRule}

  @derive {Poison.Encoder,
           only: [
             :feature_toggle_id,
             :type,
             :attribute_name,
             :attribute_value,
             :attribute_operation,
             :threshold
           ]}

  schema "feature_toggle_rules" do
    field(:attribute_name, :string)
    field(:type, :string)
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
      :type,
      :attribute_name,
      :attribute_value,
      :attribute_operation,
      :threshold
    ])
    |> validate_required([:feature_toggle_id, :type])
    |> validate_required_fields(attrs)
    |> validate_number(:threshold, less_than_or_equal_to: 1.0, greater_than_or_equal_to: 0.0)
  end

  defp validate_required_fields(changeset, attrs) do
    case attrs[:type] do
      "godsend" -> validate_godsend(changeset, attrs)
      "attributes_based" -> validate_attributes_based(changeset, attrs)
      "godsend_attributes_based" -> validate_godsend_attributes_based(changeset, attrs)
      _ -> changeset
    end
  end

  defp validate_godsend_attributes_based(changeset, attrs) do
    case Enum.all?(
           [:attribute_name, :attribute_value, :attribute_operation],
           &Map.has_key?(attrs, &1)
         ) do
      true ->
        changeset

      _ ->
        validate_required(changeset, [
          :threshold,
          :attribute_name,
          :attribute_value,
          :attribute_operation
        ])
    end
  end

  defp validate_attributes_based(changeset, attrs) do
    case Enum.all?(
           [:attribute_name, :attribute_value, :attribute_operation],
           &Map.has_key?(attrs, &1)
         ) do
      true -> changeset
      _ -> validate_required(changeset, [:attribute_name, :attribute_value, :attribute_operation])
    end
  end

  defp validate_godsend(changeset, attrs) do
    case Map.has_key?(attrs, :threshold) do
      true -> changeset
      _ -> validate_required(changeset, [:threshold])
    end
  end
end
