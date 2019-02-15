defmodule SwitchWeb.UsersCachedRepository do
  alias Switch.UsersCache
  alias SwitchWeb.UsersRepository

  def get(id: id) do
    cached_user = atomize(id) |> UsersCache.lookup()

    case cached_user do
      nil -> cache_and_return(id)
      _ -> cached_user
    end
  end

  def get(external_id: external_id, user_source: user_source) do
    cached_user = cache_key(external_id, user_source) |> atomize() |> UsersCache.lookup()

    case cached_user do
      nil -> cache_and_return(external_id, user_source)
      _ -> cached_user
    end
  end

  defp atomize(id) do
    cond do
      Kernel.is_bitstring(id) -> String.to_atom(id)
      Kernel.is_integer(id) -> String.to_atom(Integer.to_string(id))
    end
  end

  defp cache_key(external_id, user_source) do
    "#{external_id}_#{user_source}"
  end

  defp cache_and_return(id) do
    db_user = UsersRepository.get(id: id)

    case db_user do
      nil ->
        nil

      _ ->
        spawn(fn -> atomize(db_user.id) |> UsersCache.insert(db_user) end)
        db_user
    end
  end

  defp cache_and_return(external_id, user_source) do
    db_user = UsersRepository.get(external_id: external_id, user_source: user_source)

    case db_user do
      nil ->
        nil

      _ ->
        spawn(fn ->
          cache_key(external_id, user_source) |> atomize() |> UsersCache.insert(db_user)
        end)

        db_user
    end
  end
end
