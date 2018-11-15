defmodule SwitchWeb.UsersController do
  use SwitchWeb, :controller

  alias SwitchWeb.UsersRepository

  def index(conn, _params) do
    users = UsersRepository.list()

    conn
    |> put_status(:ok)
    |> json(users)
  end

  def show(conn, params) do
    user = UsersRepository.get(params["id"])

    case user do
      nil -> conn |> put_status(:not_found) |> json(:not_found)
      _ -> conn |> put_status(:ok) |> json(user)
    end
  end

  def create(conn, params) do
    {:ok, user} = UsersRepository.save(params)

    conn
    |> put_status(:created)
    |> json(user)
  end

  def delete(conn, params) do
    UsersRepository.delete(params["id"])

    conn
    |> put_status(:ok)
    |> json(:ok)
  end

  def update(conn, params) do
    {:ok, user} = UsersRepository.update(params["id"], params)

    conn
    |> put_status(:ok)
    |> json(user)
  end
end
