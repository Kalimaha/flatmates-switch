defmodule SwitchWeb.UsersRepository do
  import Ecto.Query

  alias Switch.Repo
  alias SwitchWeb.User

  def save(user: user) do
    User.changeset(%User{}, user)
    |> Repo.insert()
  end

  def list do
    Repo.all(User)
  end

  def delete(id: id) do
    get(id: id)
    |> Repo.delete()
  end

  def update(id: id, new_params: new_params) do
    record = get(id: id)

    User.changeset(record, new_params)
    |> Repo.update()
  end

  def get(id: id) do
    Repo.get(User, id)
  end

  def get(external_id: external_id, user_source: user_source) do
    from(u in User, where: u.external_id == ^external_id and u.source == ^user_source)
    |> Repo.one()
  end
end
