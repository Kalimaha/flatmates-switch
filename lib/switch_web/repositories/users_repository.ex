defmodule SwitchWeb.UsersRepository do
  alias Switch.Repo
  alias SwitchWeb.User

  def save(user) do
    User.changeset(%User{}, user)
    |> Repo.insert()
  end

  def list do
    Repo.all(User)
  end

  def delete(id) do
    get(id)
    |> Repo.delete()
  end

  def get(id) do
    Repo.get(User, id)
  end

  def update(id, new_params) do
    record = get(id)

    User.changeset(record, new_params)
    |> Repo.update()
  end
end
