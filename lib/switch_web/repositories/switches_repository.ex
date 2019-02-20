defmodule SwitchWeb.SwitchesRepository do
  import Ecto.Query

  alias Switch.Repo
  alias SwitchWeb.{Switch, FeatureToggle}

  def save(switch: switch) do
    Switch.changeset(%Switch{}, switch)
    |> Repo.insert()
  end

  def list do
    Repo.all(Switch)
  end

  def delete(id: id) do
    get(id: id)
    |> Repo.delete()
  end

  def get(id: id) do
    Repo.get(Switch, id)
    |> Repo.preload(:feature_toggle)
  end

  def get(
        user_external_id: user_external_id,
        user_source: user_source,
        feature_toggle_name: feature_toggle_name,
        feature_toggle_env: feature_toggle_env
      ) do
    from(
      s in Switch,
      join: ft in FeatureToggle,
      where:
        s.user_id == ^user_external_id and s.feature_toggle_id == ft.id and
          s.user_source == ^user_source and ft.external_id == ^feature_toggle_name and
          ft.env == ^feature_toggle_env
    )
    |> Repo.one()
  end

  def get(
        feature_toggle_name: feature_toggle_name,
        feature_toggle_env: feature_toggle_env
      ) do
    from(
      s in Switch,
      join: ft in FeatureToggle,
      where:
        s.feature_toggle_id == ft.id and ft.external_id == ^feature_toggle_name and
          ft.env == ^feature_toggle_env
    )
    |> Repo.one()
  end

  def update(id: id, new_params: new_params) do
    record = get(id: id)

    Switch.changeset(record, new_params)
    |> Repo.update()
  end
end
