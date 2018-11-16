defmodule SwitchWeb.SwitchesRepository do
  import Ecto.Query

  alias Switch.Repo
  alias SwitchWeb.Switch

  def save(switch) do
    Switch.changeset(%Switch{}, switch)
    |> Repo.insert()
  end

  def list do
    Repo.all(Switch)
  end

  def list(user_id) do
    from(s in Switch, where: s.user_id == ^user_id)
    |> Repo.all()
  end

  def delete(id) do
    get(id)
    |> Repo.delete()
  end

  def get(id) do
    Repo.get(Switch, id)
  end

  def update(id, new_params) do
    record = get(id)

    Switch.changeset(record, new_params)
    |> Repo.update()
  end
end
