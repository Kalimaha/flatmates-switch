defmodule SwitchWeb.UsersControllerTest do
  use SwitchWeb.ConnCase

  alias SwitchWeb.{User, UsersRepository}

  @user %{external_id: "spam", source: "flatmates"}

  test "returns an empty array when there are no users available", %{conn: conn} do
    response = conn |> get(users_path(conn, :index)) |> json_response(:ok)

    assert response == []
  end

  test "returns all the available users", %{conn: conn} do
    {:ok, record} = UsersRepository.save(@user)

    expected = [
      %{"external_id" => record.external_id, "id" => record.id, "source" => "flatmates"}
    ]

    response = conn |> get(users_path(conn, :index)) |> json_response(:ok)

    assert response == expected
  end

  test "inserts a new record in the DB", %{conn: conn} do
    conn
    |> post(users_path(conn, :create, @user), @user)
    |> json_response(:created)

    assert length(UsersRepository.list()) == 1
  end

  test "deletes record from the DB", %{conn: conn} do
    {:ok, record} = UsersRepository.save(@user)

    conn
    |> delete(users_path(conn, :delete, %User{id: record.id}))
    |> json_response(:ok)

    assert length(UsersRepository.list()) == 0
  end

  test "updates existing records in the DB", %{conn: conn} do
    {:ok, record} = UsersRepository.save(@user)

    conn
    |> put(users_path(conn, :update, record.id), %{
      :external_id => "eggs",
      :source => "test"
    })
    |> json_response(:ok)

    assert UsersRepository.get(record.id).external_id == "eggs"
    assert UsersRepository.get(record.id).source == "test"
  end

  test "returns single user", %{conn: conn} do
    {:ok, record} = UsersRepository.save(@user)

    response = conn |> get(users_path(conn, :show, record.id)) |> json_response(:ok)

    assert response == %{
             "id" => record.id,
             "external_id" => "spam",
             "source" => "flatmates"
           }
  end

  test "attempt to get a missing model", %{conn: conn} do
    response = conn |> get(users_path(conn, :show, 42)) |> json_response(:not_found)

    assert response == "not_found"
  end
end
