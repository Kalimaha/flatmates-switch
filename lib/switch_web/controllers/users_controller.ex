defmodule SwitchWeb.UsersController do
  use SwitchWeb, :controller

  alias SwitchWeb.{UsersRepository, UsersCachedRepository}

  def index(%{assigns: %{version: :v1}} = conn, _params) do
    users = UsersRepository.list()

    conn
    |> put_status(:ok)
    |> json(users)
  end

  def show(%{assigns: %{version: :v1}} = conn, params) do
    user = UsersCachedRepository.get(id: params["id"])

    case user do
      nil -> conn |> put_status(:not_found) |> json(:not_found)
      _ -> conn |> put_status(:ok) |> json(user)
    end
  end

  def create(%{assigns: %{version: :v1}} = conn, params) do
    {:ok, user} = UsersRepository.save(user: params)

    conn
    |> put_status(:created)
    |> json(user)
  end

  def delete(%{assigns: %{version: :v1}} = conn, params) do
    UsersRepository.delete(id: params["id"])

    conn
    |> put_status(:ok)
    |> json(:ok)
  end

  def update(%{assigns: %{version: :v1}} = conn, params) do
    {:ok, user} = UsersRepository.update(id: params["id"], new_params: params)

    conn
    |> put_status(:ok)
    |> json(user)
  end
end
