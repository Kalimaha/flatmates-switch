defmodule SwitchWeb.UsersRepository do
  import Ecto.Query

  alias Switch.Repo
  alias SwitchWeb.{User, CacheHelper}

  def save(user: user) do
    User.changeset(%User{}, user)
    |> Repo.insert()
  end

  def list do
    Repo.all(User)
  end

  def delete(id: id) do
    {:ok, user} = get(id: id) |> Repo.delete()

    CacheHelper.clear_cache(user: user)

    {:ok, user}
  end

  def update(id: id, new_params: new_params) do
    {:ok, user} = get(id: id) |> User.changeset(new_params) |> Repo.update()

    CacheHelper.clear_cache(user: user)

    {:ok, user}
  end

  def get(id: id) do
    Repo.get(User, id)
  end

  def get(external_id: external_id, user_source: user_source) do
    from(u in User, where: u.external_id == ^external_id and u.source == ^user_source)
    |> Repo.one()
  end
end
